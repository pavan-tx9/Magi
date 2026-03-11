import SwiftUI

// MARK: - Oscilloscope Waveform

public struct OscilloscopeView: View {
    @State private var phase: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme
    public var color: Color?
    public var amplitude: Double
    public var frequency: Double

    public init(color: Color? = nil, amplitude: Double = 0.8, frequency: Double = 3) {
        self.color = color
        self.amplitude = amplitude
        self.frequency = frequency
    }

    public var body: some View {
        let resolved = color ?? theme.accentSuccess
        let intensity = theme.style.glowIntensity
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
            context.stroke(path, with: .color(resolved), lineWidth: 1.5)
            context.stroke(path, with: .color(resolved.opacity(0.3 * intensity)), lineWidth: 4)
        }
        .onAppear {
            guard !reduceMotion else { return }
            animate()
        }
        .accessibilityLabel("Oscilloscope waveform")
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let gridColor = theme.border
        for i in 0...8 {
            let x = size.width * CGFloat(i) / 8
            var line = Path()
            line.move(to: CGPoint(x: x, y: 0))
            line.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(line, with: .color(gridColor), lineWidth: 0.5)
        }
        for i in 0...4 {
            let y = size.height * CGFloat(i) / 4
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
    public var color: Color?
    public var size: CGFloat
    @Environment(\.magiTheme) private var theme
    private var angle: Double { value * 270 }

    public init(value: Double, label: String, color: Color? = nil, size: CGFloat = 90) {
        self.value = value
        self.label = label
        self.color = color
        self.size = size
    }

    public var body: some View {
        let resolved = color ?? theme.accent
        let arcWidth = theme.style.borderWidth * 3
        ZStack {
            Arc(startAngle: .degrees(135), endAngle: .degrees(45))
                .stroke(theme.border, lineWidth: arcWidth)
                .frame(width: size, height: size)
            Arc(startAngle: .degrees(135), endAngle: .degrees(135 + angle))
                .stroke(resolved, lineWidth: arcWidth)
                .frame(width: size, height: size)
                .shadow(color: theme.style.glowIntensity > 0 ? resolved.opacity(0.4 * theme.style.glowIntensity) : .clear, radius: 6)
            ForEach(0..<10) { i in
                let tickAngle = 135.0 + (Double(i) / 9.0 * 270.0)
                Rectangle()
                    .fill(theme.textMuted)
                    .frame(width: 1, height: 5)
                    .offset(y: -(size / 2 - 2))
                    .rotationEffect(.degrees(tickAngle))
            }
            VStack(spacing: 0) {
                Text("\(Int(value * 100))")
                    .font(.system(size: size * 0.25, weight: theme.style.headingWeight, design: .monospaced))
                    .foregroundStyle(resolved)
                Text(label.uppercased())
                    .font(.system(size: 8, weight: theme.style.buttonWeight, design: .monospaced))
                    .tracking(theme.style.labelTracking - 0.5)
                    .foregroundStyle(theme.textMuted)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label) gauge")
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}

// MARK: - Bar Chart

public struct BarChart: View {
    public let data: [(String, Double, Color)]
    public var height: CGFloat
    @Environment(\.magiTheme) private var theme

    public init(data: [(String, Double, Color)], height: CGFloat = 100) {
        self.data = data
        self.height = height
    }

    public var body: some View {
        let intensity = theme.style.glowIntensity
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data, id: \.0) { item in
                    VStack(spacing: 3) {
                        Rectangle()
                            .fill(item.2)
                            .frame(height: max(2, height * item.1))
                            .shadow(color: intensity > 0 ? item.2.opacity(0.2 * intensity) : .clear, radius: 4)
                        Text(item.0)
                            .font(.system(size: 8, weight: theme.style.buttonWeight, design: .monospaced))
                            .tracking(0.5)
                            .foregroundStyle(theme.textMuted)
                    }
                }
            }
            .frame(height: height + 16)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(barChartAccessibilityLabel)
    }

    private var barChartAccessibilityLabel: String {
        let items = data.map { "\($0.0): \(Int($0.1 * 100))%" }
        return "Bar chart. \(items.joined(separator: ", "))"
    }
}

// MARK: - Sparkline

public struct Sparkline: View {
    public let data: [Double]
    public var color: Color?
    public var height: CGFloat
    @Environment(\.magiTheme) private var theme

    public init(data: [Double], color: Color? = nil, height: CGFloat = 30) {
        self.data = data
        self.color = color
        self.height = height
    }

    public var body: some View {
        let resolved = color ?? theme.accentSecondary
        let intensity = theme.style.glowIntensity
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
                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
            context.stroke(path, with: .color(resolved), lineWidth: 1.5)
            context.stroke(path, with: .color(resolved.opacity(0.2 * intensity)), lineWidth: 4)

            var fillPath = path
            fillPath.addLine(to: CGPoint(x: size.width, y: size.height))
            fillPath.addLine(to: CGPoint(x: 0, y: size.height))
            fillPath.closeSubpath()
            context.fill(fillPath, with: .color(resolved.opacity(0.05)))
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(sparklineAccessibilityLabel)
    }

    private var sparklineAccessibilityLabel: String {
        guard let min = data.min(), let max = data.max() else {
            return "Sparkline chart, no data"
        }
        return "Sparkline chart, \(data.count) points, range \(Int(min)) to \(Int(max))"
    }
}
