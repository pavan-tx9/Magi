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
    @State private var startDate = Date.now
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
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let sweepAngle = elapsed.truncatingRemainder(dividingBy: 3) / 3 * 360

            Canvas { context, _ in
                let half = size / 2
                drawGrid(context: context, cx: half, cy: half, radius: half)
                drawSweep(context: context, cx: half, cy: half, radius: half, angle: sweepAngle, color: resolved)
                drawSweepLine(context: context, cx: half, cy: half, radius: half, angle: sweepAngle, color: resolved)
                drawBlips(context: context, cx: half, cy: half, radius: half, color: resolved, intensity: intensity)
                drawCenter(context: context, cx: half, cy: half, color: resolved)
            }
        }
        .frame(width: size, height: size)
        .fixedSize()
        .accessibilityLabel("Radar, \(blips.count) contacts")
    }
}

private extension RadarView {

    func drawGrid(context: GraphicsContext, cx: CGFloat, cy: CGFloat, radius: CGFloat) {
        let borderColor = theme.border
        for ring in 1..<4 {
            let r = radius * CGFloat(ring) / 3
            var circle = Path()
            circle.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
            context.stroke(circle, with: .color(borderColor), lineWidth: 0.5)
        }
        var hLine = Path()
        hLine.move(to: CGPoint(x: cx - radius, y: cy))
        hLine.addLine(to: CGPoint(x: cx + radius, y: cy))
        context.stroke(hLine, with: .color(borderColor), lineWidth: 0.5)
        var vLine = Path()
        vLine.move(to: CGPoint(x: cx, y: cy - radius))
        vLine.addLine(to: CGPoint(x: cx, y: cy + radius))
        context.stroke(vLine, with: .color(borderColor), lineWidth: 0.5)
    }

    func drawSweep(context: GraphicsContext, cx: CGFloat, cy: CGFloat, radius: CGFloat, angle: Double, color: Color) {
        let sweepSpan = 40.0
        let steps = 8
        for i in 0..<steps {
            let frac = Double(i) / Double(steps)
            let startDeg = angle - sweepSpan + frac * sweepSpan
            let endDeg = startDeg + sweepSpan / Double(steps)
            let alpha = 0.03 + frac * 0.08

            var wedge = Path()
            wedge.move(to: CGPoint(x: cx, y: cy))
            wedge.addArc(
                center: CGPoint(x: cx, y: cy), radius: radius,
                startAngle: .degrees(startDeg - 90), endAngle: .degrees(endDeg - 90),
                clockwise: false
            )
            wedge.closeSubpath()
            context.fill(wedge, with: .color(color.opacity(alpha)))
        }
    }

    func drawSweepLine(context: GraphicsContext, cx: CGFloat, cy: CGFloat, radius: CGFloat, angle: Double, color: Color) {
        let rad = Angle.degrees(angle - 90).radians
        var line = Path()
        line.move(to: CGPoint(x: cx, y: cy))
        line.addLine(to: CGPoint(x: cx + Foundation.cos(rad) * radius, y: cy + Foundation.sin(rad) * radius))
        context.stroke(line, with: .color(color.opacity(0.8)), lineWidth: 1)
    }

    func drawBlips(context: GraphicsContext, cx: CGFloat, cy: CGFloat, radius: CGFloat, color: Color, intensity: Double) {
        for blip in blips {
            let bx = cx + blip.x * radius
            let by = cy + blip.y * radius
            let blipRect = CGRect(x: bx - 2, y: by - 2, width: 4, height: 4)
            context.fill(Path(ellipseIn: blipRect), with: .color(color))
            if intensity > 0 {
                let glowRect = CGRect(x: bx - 4, y: by - 4, width: 8, height: 8)
                context.fill(Path(ellipseIn: glowRect), with: .color(color.opacity(0.15 * intensity)))
            }
        }
    }

    func drawCenter(context: GraphicsContext, cx: CGFloat, cy: CGFloat, color: Color) {
        let centerRect = CGRect(x: cx - 1.5, y: cy - 1.5, width: 3, height: 3)
        context.fill(Path(ellipseIn: centerRect), with: .color(color))
    }
}
