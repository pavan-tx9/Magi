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
        VStack(spacing: 3) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 3) {
                    let offset: CGFloat = row.isMultiple(of: 2) ? 0 : 10
                    Spacer().frame(width: offset)

                    ForEach(0..<columns, id: \.self) { col in
                        let idx = row * columns + col
                        if idx < statuses.count {
                            HexCell(color: statuses[idx])
                        }
                    }

                    if !row.isMultiple(of: 2) {
                        Spacer().frame(width: 10)
                    }
                }
            }
        }
    }
}

public struct HexCell: View {
    public let color: Color

    public init(color: Color) {
        self.color = color
    }

    public var body: some View {
        HexShape()
            .fill(color.opacity(0.15))
            .overlay { HexShape().stroke(color.opacity(0.5), lineWidth: 1) }
            .frame(width: 20, height: 18)
    }
}

public struct HexShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = rect.midX
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
    public var color: Color
    public var size: CGFloat

    public init(color: Color = MagiColor.accentRed, size: CGFloat = 120) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 1)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(color, lineWidth: 2)
                .frame(width: size * 0.85, height: size * 0.85)
                .rotationEffect(.degrees(rotation))
                .shadow(color: color.opacity(0.4), radius: 6)

            Circle()
                .trim(from: 0.5, to: 0.75)
                .stroke(color, lineWidth: 2)
                .frame(width: size * 0.85, height: size * 0.85)
                .rotationEffect(.degrees(rotation))
                .shadow(color: color.opacity(0.4), radius: 6)

            Circle()
                .trim(from: 0, to: 0.15)
                .stroke(MagiColor.accentCyan, lineWidth: 1)
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(.degrees(-rotation * 1.5))

            Circle()
                .trim(from: 0.5, to: 0.65)
                .stroke(MagiColor.accentCyan, lineWidth: 1)
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(.degrees(-rotation * 1.5))

            ForEach(0..<4, id: \.self) { i in
                Rectangle()
                    .fill(color.opacity(0.5))
                    .frame(width: 1, height: size * 0.15)
                    .offset(y: -size * 0.3)
                    .rotationEffect(.degrees(Double(i) * 90))
            }

            Circle()
                .fill(color)
                .frame(width: 4, height: 4)
                .scaleEffect(pulse)
                .shadow(color: color.opacity(0.6), radius: 8)
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                pulse = 1.4
            }
        }
    }
}

// MARK: - Boot Sequence

public struct BootSequence: View {
    @State private var lines: [BootLine] = []
    @State private var currentIndex = 0

    private let bootMessages: [(String, Color, Double)] = [
        ("MAGI SYSTEM v0.1.0", MagiColor.accentRed, 0.0),
        ("Initializing core modules...", MagiColor.textMuted, 0.3),
        ("[OK] Task engine loaded", MagiColor.accentGreen, 0.6),
        ("[OK] Persistence layer connected", MagiColor.accentGreen, 0.9),
        ("[OK] UI subsystem ready", MagiColor.accentGreen, 1.2),
        ("[WARN] Memory cache at 87%", MagiColor.accentAmber, 1.6),
        ("[OK] Network interface bound", MagiColor.accentGreen, 2.0),
        ("Running diagnostics...", MagiColor.textMuted, 2.4),
        ("All systems nominal.", MagiColor.accentCyan, 3.0),
        ("READY.", MagiColor.accentRed, 3.4),
    ]

    public init() {}

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
    }

    private func runSequence() {
        for (index, message) in bootMessages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + message.2) {
                lines.append(BootLine(text: message.0, color: message.1))
                currentIndex = index + 1
            }
        }
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

// MARK: - Scrolling Data Stream

public struct DataStream: View {
    @State private var offset: CGFloat = 0
    public var color: Color

    private let chars = "0123456789ABCDEF"
    private let columns = 16
    private let rows = 6

    public init(color: Color = MagiColor.accentGreen) {
        self.color = color
    }

    public var body: some View {
        Canvas { context, size in
            let cellW = size.width / CGFloat(columns)
            let cellH = size.height / CGFloat(rows)

            for row in 0..<rows {
                for col in 0..<columns {
                    let seed = (row * columns + col + Int(offset)) * 7
                    let charIndex = abs(seed) % chars.count
                    let char = String(chars[chars.index(chars.startIndex, offsetBy: charIndex)])

                    let opacity = 0.2 + Double((row + Int(offset / 3)) % rows) / Double(rows) * 0.8
                    let point = CGPoint(x: CGFloat(col) * cellW + 4, y: CGFloat(row) * cellH + 2)

                    context.drawLayer { ctx in
                        ctx.opacity = opacity
                        ctx.draw(
                            Text(char)
                                .font(.system(size: 11, weight: .regular, design: .monospaced))
                                .foregroundColor(color),
                            at: point,
                            anchor: .topLeading
                        )
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: false)) {
                offset = 100
            }
        }
    }
}

// MARK: - Radar Sweep

public struct RadarView: View {
    @State private var sweepAngle: Double = 0
    public var color: Color
    public var size: CGFloat

    private let blips: [CGPoint] = [
        CGPoint(x: 0.3, y: -0.2),
        CGPoint(x: -0.15, y: 0.35),
        CGPoint(x: 0.5, y: 0.1),
        CGPoint(x: -0.4, y: -0.3),
        CGPoint(x: 0.1, y: -0.45),
    ]

    public init(color: Color = MagiColor.accentGreen, size: CGFloat = 140) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        ZStack {
            ForEach(1..<4, id: \.self) { ring in
                Circle()
                    .stroke(MagiColor.border, lineWidth: 0.5)
                    .frame(
                        width: size * CGFloat(ring) / 3,
                        height: size * CGFloat(ring) / 3
                    )
            }

            Rectangle()
                .fill(MagiColor.border)
                .frame(width: size, height: 0.5)
            Rectangle()
                .fill(MagiColor.border)
                .frame(width: 0.5, height: size)

            AngularGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: color.opacity(0.3), location: 0.95),
                    .init(color: color.opacity(0.6), location: 1.0),
                ],
                center: .center,
                startAngle: .degrees(sweepAngle - 40),
                endAngle: .degrees(sweepAngle)
            )
            .clipShape(Circle())
            .frame(width: size, height: size)

            Rectangle()
                .fill(color)
                .frame(width: 1, height: size / 2)
                .offset(y: -size / 4)
                .rotationEffect(.degrees(sweepAngle))
                .shadow(color: color.opacity(0.5), radius: 4)

            ForEach(0..<blips.count, id: \.self) { i in
                let blip = blips[i]
                Circle()
                    .fill(color)
                    .frame(width: 4, height: 4)
                    .shadow(color: color.opacity(0.6), radius: 4)
                    .offset(
                        x: blip.x * size / 2,
                        y: blip.y * size / 2
                    )
            }

            Circle()
                .fill(color)
                .frame(width: 3, height: 3)
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                sweepAngle = 360
            }
        }
    }
}
