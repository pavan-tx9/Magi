import SwiftUI

// MARK: - Scrolling Data Stream

public struct DataStream: View {
    @State private var offset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme
    public var color: Color?

    private let chars = "0123456789ABCDEF"
    private let columns = 16
    private let rows = 6

    public init(color: Color? = nil) {
        self.color = color
    }

    public var body: some View {
        let resolved = color ?? theme.accentSuccess
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
                                .foregroundStyle(resolved),
                            at: point,
                            anchor: .topLeading
                        )
                    }
                }
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: false)) {
                offset = 100
            }
        }
        .accessibilityLabel("Data stream")
    }
}

// MARK: - Radar Sweep

public struct RadarView: View {
    @State private var sweepAngle: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme
    public var color: Color?
    public var size: CGFloat

    private let blips: [CGPoint] = [
        CGPoint(x: 0.3, y: -0.2),
        CGPoint(x: -0.15, y: 0.35),
        CGPoint(x: 0.5, y: 0.1),
        CGPoint(x: -0.4, y: -0.3),
        CGPoint(x: 0.1, y: -0.45),
    ]

    public init(color: Color? = nil, size: CGFloat = 140) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        let resolved = color ?? theme.accentSuccess
        let intensity = theme.style.glowIntensity
        ZStack {
            ForEach(1..<4, id: \.self) { ring in
                Circle()
                    .stroke(theme.border, lineWidth: 0.5)
                    .frame(
                        width: size * CGFloat(ring) / 3,
                        height: size * CGFloat(ring) / 3
                    )
            }

            Rectangle()
                .fill(theme.border)
                .frame(width: size, height: 0.5)
            Rectangle()
                .fill(theme.border)
                .frame(width: 0.5, height: size)

            // Sweep trail — flat color arcs at decreasing opacity
            ForEach(0..<4, id: \.self) { i in
                let segAngle = 10.0
                let offset = Double(i) * segAngle
                Circle()
                    .trim(
                        from: CGFloat((sweepAngle - 40 + offset) / 360).truncatingRemainder(dividingBy: 1),
                        to: CGFloat((sweepAngle - 40 + offset + segAngle) / 360).truncatingRemainder(dividingBy: 1)
                    )
                    .stroke(resolved.opacity(0.15 + Double(i) * 0.15), lineWidth: size / 2)
                    .frame(width: size, height: size)
            }
            .clipShape(Circle())

            Rectangle()
                .fill(resolved)
                .frame(width: 1, height: size / 2)
                .offset(y: -size / 4)
                .rotationEffect(.degrees(sweepAngle))

            ForEach(0..<blips.count, id: \.self) { i in
                let blip = blips[i]
                Circle()
                    .fill(resolved)
                    .frame(width: 4, height: 4)
                    .shadow(color: intensity > 0 ? resolved.opacity(0.6 * intensity) : .clear, radius: 4)
                    .offset(
                        x: blip.x * size / 2,
                        y: blip.y * size / 2
                    )
            }

            Circle()
                .fill(resolved)
                .frame(width: 3, height: 3)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                sweepAngle = 360
            }
        }
        .accessibilityLabel("Radar, \(blips.count) contacts")
    }
}
