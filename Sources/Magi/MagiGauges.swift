import SwiftUI

// MARK: - Oscilloscope Waveform

public struct OscilloscopeView: View {
    @State private var phase: Double = 0
    public var color: Color
    public var amplitude: Double
    public var frequency: Double

    public init(color: Color = MagiColor.accentGreen, amplitude: Double = 0.8, frequency: Double = 3) {
        self.color = color
        self.amplitude = amplitude
        self.frequency = frequency
    }

    public var body: some View {
        Canvas { context, size in
            let midY = size.height / 2
            let step: CGFloat = 2

            drawGrid(context: context, size: size)

            var path = Path()
            var started = false
            var x: CGFloat = 0
            while x <= size.width {
                let normalized = x / size.width
                let y = midY - sin((normalized * frequency * .pi * 2) + phase) * midY * amplitude
                if !started {
                    path.move(to: CGPoint(x: x, y: y))
                    started = true
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                x += step
            }
            context.stroke(path, with: .color(color), lineWidth: 1.5)
            context.stroke(path, with: .color(color.opacity(0.3)), lineWidth: 4)
        }
        .onAppear { animate() }
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let gridColor = MagiColor.border
        let cols = 8
        let rows = 4
        for i in 0...cols {
            let x = size.width * CGFloat(i) / CGFloat(cols)
            var line = Path()
            line.move(to: CGPoint(x: x, y: 0))
            line.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(line, with: .color(gridColor), lineWidth: 0.5)
        }
        for i in 0...rows {
            let y = size.height * CGFloat(i) / CGFloat(rows)
            var line = Path()
            line.move(to: CGPoint(x: 0, y: y))
            line.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(line, with: .color(gridColor), lineWidth: 0.5)
        }
    }

    private func animate() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            phase = .pi * 2
        }
    }
}

// MARK: - Circular Gauge

public struct CircularGauge: View {
    public let value: Double
    public let label: String
    public var color: Color
    public var size: CGFloat

    private var angle: Double { value * 270 }

    public init(value: Double, label: String, color: Color = MagiColor.accentRed, size: CGFloat = 90) {
        self.value = value
        self.label = label
        self.color = color
        self.size = size
    }

    public var body: some View {
        ZStack {
            Arc(startAngle: .degrees(135), endAngle: .degrees(45))
                .stroke(MagiColor.border, lineWidth: 3)
                .frame(width: size, height: size)

            Arc(startAngle: .degrees(135), endAngle: .degrees(135 + angle))
                .stroke(color, lineWidth: 3)
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.4), radius: 6)

            ForEach(0..<10) { i in
                let tickAngle = 135.0 + (Double(i) / 9.0 * 270.0)
                Rectangle()
                    .fill(MagiColor.textMuted)
                    .frame(width: 1, height: 5)
                    .offset(y: -(size / 2 - 2))
                    .rotationEffect(.degrees(tickAngle))
            }

            VStack(spacing: 0) {
                Text("\(Int(value * 100))")
                    .font(.system(size: size * 0.25, weight: .semibold, design: .monospaced))
                    .foregroundStyle(color)

                Text(label.uppercased())
                    .font(.system(size: 7, weight: .medium, design: .monospaced))
                    .tracking(1)
                    .foregroundStyle(MagiColor.textMuted)
            }
        }
    }
}

// MARK: - Bar Chart

public struct BarChart: View {
    public let data: [(String, Double, Color)]
    public var height: CGFloat

    public init(data: [(String, Double, Color)], height: CGFloat = 100) {
        self.data = data
        self.height = height
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data, id: \.0) { item in
                    VStack(spacing: 3) {
                        Rectangle()
                            .fill(item.2)
                            .frame(height: max(2, height * item.1))
                            .shadow(color: item.2.opacity(0.2), radius: 4)

                        Text(item.0)
                            .font(.system(size: 7, weight: .medium, design: .monospaced))
                            .tracking(0.5)
                            .foregroundStyle(MagiColor.textMuted)
                    }
                }
            }
            .frame(height: height + 16)
        }
    }
}

// MARK: - Sparkline

public struct Sparkline: View {
    public let data: [Double]
    public var color: Color
    public var height: CGFloat

    public init(data: [Double], color: Color = MagiColor.accentCyan, height: CGFloat = 30) {
        self.data = data
        self.color = color
        self.height = height
    }

    public var body: some View {
        Canvas { context, size in
            guard data.count > 1 else { return }

            let maxVal = data.max() ?? 1
            let minVal = data.min() ?? 0
            let range = max(maxVal - minVal, 0.01)
            let stepX = size.width / CGFloat(data.count - 1)

            var path = Path()
            for (i, val) in data.enumerated() {
                let x = CGFloat(i) * stepX
                let normalized = (val - minVal) / range
                let y = size.height - (normalized * size.height)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }

            context.stroke(path, with: .color(color), lineWidth: 1.5)
            context.stroke(path, with: .color(color.opacity(0.2)), lineWidth: 4)

            var fillPath = path
            fillPath.addLine(to: CGPoint(x: size.width, y: size.height))
            fillPath.addLine(to: CGPoint(x: 0, y: size.height))
            fillPath.closeSubpath()
            context.fill(fillPath, with: .color(color.opacity(0.05)))
        }
        .frame(height: height)
    }
}
