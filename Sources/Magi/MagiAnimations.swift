import SwiftUI

// MARK: - Hex Status Grid

public struct HexGrid: View {
    public let statuses: [Color]
    public let columns: Int

    public init(statuses: [Color], columns: Int) {
        self.statuses = statuses
        self.columns = columns
    }

    public var body: some View {
        let rows = (statuses.count + columns - 1) / columns
        VStack(alignment: .leading, spacing: 3) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 3) {
                    ForEach(0..<columns, id: \.self) { col in
                        let idx = row * columns + col
                        if idx < statuses.count {
                            HexCell(color: statuses[idx])
                        }
                    }
                }
                .padding(.leading, row.isMultiple(of: 2) ? 0 : 10)
            }
        }
        .fixedSize()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Status grid, \(statuses.count) cells")
    }
}

public struct HexCell: View {
    public let color: Color
    @Environment(\.colorSchemeContrast) private var contrast

    public init(color: Color) { self.color = color }

    public var body: some View {
        HexShape()
            .fill(color.opacity(contrast == .increased ? 0.35 : 0.15))
            .overlay { HexShape().stroke(color.opacity(contrast == .increased ? 0.85 : 0.5), lineWidth: 1) }
            .frame(width: 20, height: 18)
    }
}

public struct HexShape: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height, cx = rect.midX
        path.move(to: CGPoint(x: cx, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.25))
        path.addLine(to: CGPoint(x: w, y: h * 0.75))
        path.addLine(to: CGPoint(x: cx, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.75))
        path.addLine(to: CGPoint(x: 0, y: h * 0.25))
        path.closeSubpath()
        return path
    }
}

// MARK: - Crosshair / Targeting Reticle

public struct ReticleView: View {
    @State private var rotation: Double = 0
    @State private var pulse: Double = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme
    public var color: Color?
    public var size: CGFloat

    public init(color: Color? = nil, size: CGFloat = 120) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        let resolved = color ?? theme.accent
        let intensity = theme.style.glowIntensity
        ZStack {
            Circle()
                .stroke(resolved.opacity(0.3), lineWidth: theme.style.borderWidth)
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(resolved, lineWidth: theme.style.borderWidth * 2)
                .frame(width: size * 0.85, height: size * 0.85)
                .rotationEffect(.degrees(rotation))
                .shadow(color: resolved.opacity(0.4 * intensity), radius: 6)
            Circle()
                .trim(from: 0.5, to: 0.75)
                .stroke(resolved, lineWidth: theme.style.borderWidth * 2)
                .frame(width: size * 0.85, height: size * 0.85)
                .rotationEffect(.degrees(rotation))
                .shadow(color: resolved.opacity(0.4 * intensity), radius: 6)
            Circle()
                .trim(from: 0, to: 0.15)
                .stroke(theme.accentSecondary, lineWidth: theme.style.borderWidth)
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(.degrees(-rotation * 1.5))
            Circle()
                .trim(from: 0.5, to: 0.65)
                .stroke(theme.accentSecondary, lineWidth: theme.style.borderWidth)
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(.degrees(-rotation * 1.5))
            ForEach(0..<4, id: \.self) { i in
                Rectangle()
                    .fill(resolved.opacity(0.5))
                    .frame(width: 1, height: size * 0.15)
                    .offset(y: -size * 0.3)
                    .rotationEffect(.degrees(Double(i) * 90))
            }
            Circle()
                .fill(resolved)
                .frame(width: 4, height: 4)
                .scaleEffect(pulse)
                .shadow(color: resolved.opacity(0.6 * intensity), radius: 8)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                pulse = 1.4
            }
        }
        .accessibilityLabel("Targeting reticle")
    }
}

// MARK: - Boot Sequence

public struct BootSequence: View {
    @State private var lines: [BootLine] = []
    @State private var currentIndex = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme

    public init() {}

    private var bootMessages: [(String, Color, Double)] {
        [
            ("MAGI SYSTEM v0.1.0", theme.accent, 0.0),
            ("Initializing core modules...", theme.textMuted, 0.3),
            ("[OK] Task engine loaded", theme.accentSuccess, 0.6),
            ("[OK] Persistence layer connected", theme.accentSuccess, 0.9),
            ("[OK] UI subsystem ready", theme.accentSuccess, 1.2),
            ("[WARN] Memory cache at 87%", theme.accentWarning, 1.6),
            ("[OK] Network interface bound", theme.accentSuccess, 2.0),
            ("Running diagnostics...", theme.textMuted, 2.4),
            ("All systems nominal.", theme.accentSecondary, 3.0),
            ("READY.", theme.accent, 3.4),
        ]
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(lines) { line in
                Text(line.text)
                    .font(MagiFont.body)
                    .foregroundStyle(line.color)
            }
            if currentIndex < bootMessages.count {
                BlinkingCursor()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { runSequence() }
        .accessibilityElement(children: .combine)
    }

    private func runSequence() {
        if reduceMotion {
            showAllLines()
            return
        }
        Task { @MainActor in
            for (index, message) in bootMessages.enumerated() {
                try? await Task.sleep(for: .seconds(index == 0 ? message.2 : message.2 - bootMessages[index - 1].2))
                lines.append(BootLine(text: message.0, color: message.1))
                currentIndex = index + 1
            }
        }
    }

    private func showAllLines() {
        lines = bootMessages.map { BootLine(text: $0.0, color: $0.1) }
        currentIndex = bootMessages.count
    }
}

public struct BootLine: Identifiable {
    public let id = UUID()
    public let text: String
    public let color: Color
    public init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
}
