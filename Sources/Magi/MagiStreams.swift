import SwiftUI

// MARK: - Scrolling Data Stream

public struct DataStream: View {
    @State private var offset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
                                .foregroundStyle(color),
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
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                sweepAngle = 360
            }
        }
        .accessibilityLabel("Radar, \(blips.count) contacts")
    }
}
