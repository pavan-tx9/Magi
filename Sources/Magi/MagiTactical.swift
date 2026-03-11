import SwiftUI

// MARK: - Sync Rate Display

public struct SyncRateDisplay: View {
    public let rates: [(label: String, value: Double, color: Color)]
    public var height: CGFloat

    @State private var startDate = Date.now
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme

    public init(rates: [(String, Double, Color)], height: CGFloat = 160) {
        self.rates = rates.map { (label: $0.0, value: $0.1, color: $0.2) }
        self.height = height
    }

    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15, paused: reduceMotion)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)

            Canvas { context, size in
                let barWidth: CGFloat = 32
                let gap: CGFloat = 20
                let totalWidth = CGFloat(rates.count) * barWidth + CGFloat(rates.count - 1) * gap
                let startX = (size.width - totalWidth) / 2
                let trackTop: CGFloat = 20
                let trackHeight = size.height - 50

                for (i, rate) in rates.enumerated() {
                    let x = startX + CGFloat(i) * (barWidth + gap)
                    drawSyncBar(
                        context: context, x: x, top: trackTop,
                        width: barWidth, trackHeight: trackHeight,
                        rate: rate, elapsed: elapsed, index: i
                    )
                }
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(syncAccessibilityLabel)
    }

    private var syncAccessibilityLabel: String {
        let items = rates.map { "\($0.label): \(Int($0.value * 100)) percent" }
        return "Sync rates. \(items.joined(separator: ", "))"
    }
}

private extension SyncRateDisplay {

    func drawSyncBar(context: GraphicsContext, x: CGFloat, top: CGFloat, width: CGFloat, trackHeight: CGFloat, rate: (label: String, value: Double, color: Color), elapsed: Double, index: Int) {
        let clamped = min(max(rate.value, 0), 1)
        let fillH = trackHeight * clamped
        let fillTop = top + trackHeight - fillH
        let bw = theme.style.borderWidth
        let intensity = theme.style.glowIntensity

        // Track background
        let trackRect = CGRect(x: x, y: top, width: width, height: trackHeight)
        context.fill(Path(trackRect), with: .color(theme.bgSurface))

        // Fill with noise texture
        let noiseStep: CGFloat = 3
        var y = fillTop
        while y < top + trackHeight {
            let noisePhase = elapsed * 4 + Double(index) * 1.7 + Double(y) * 0.1
            let noise = sin(noisePhase) * 0.15 + sin(noisePhase * 2.3) * 0.1
            let alpha = 0.6 + noise
            let lineRect = CGRect(x: x + 1, y: y, width: width - 2, height: min(noiseStep, top + trackHeight - y))
            context.fill(Path(lineRect), with: .color(rate.color.opacity(alpha)))
            y += noiseStep
        }

        // Horizontal scan lines over fill
        var scanPath = Path()
        var scanY = fillTop
        while scanY < top + trackHeight {
            scanPath.addRect(CGRect(x: x + 1, y: scanY, width: width - 2, height: 1))
            scanY += 4
        }
        context.fill(scanPath, with: .color(theme.bgPrimary.opacity(0.15)))

        // Bright line at fill top edge
        if clamped > 0.01 {
            let edgeRect = CGRect(x: x, y: fillTop, width: width, height: 1.5)
            context.fill(Path(edgeRect), with: .color(rate.color.opacity(0.9)))
            if intensity > 0 {
                let glowRect = CGRect(x: x - 2, y: fillTop - 2, width: width + 4, height: 5)
                context.fill(Path(glowRect), with: .color(rate.color.opacity(0.12 * intensity)))
            }
        }

        // Track border
        context.stroke(Path(trackRect), with: .color(theme.border), lineWidth: bw)

        // Tick marks on left side
        var tickPath = Path()
        for tick in 0..<5 {
            let tickY = top + trackHeight * CGFloat(tick) / 4
            tickPath.move(to: CGPoint(x: x - 3, y: tickY))
            tickPath.addLine(to: CGPoint(x: x, y: tickY))
        }
        context.stroke(tickPath, with: .color(theme.border.opacity(0.5)), lineWidth: 0.5)

        // Percentage readout above
        let pctText = context.resolve(Text("\(Int(clamped * 100))%")
            .font(.system(size: 12, weight: theme.style.headingWeight, design: .monospaced))
            .foregroundColor(rate.color))
        context.draw(pctText, at: CGPoint(x: x + width / 2, y: top - 6), anchor: .bottom)

        // Label below
        let labelText = context.resolve(Text(rate.label)
            .font(.system(size: 8, weight: theme.style.buttonWeight, design: .monospaced))
            .foregroundColor(theme.textMuted))
        context.draw(labelText, at: CGPoint(x: x + width / 2, y: top + trackHeight + 8), anchor: .top)
    }
}

// MARK: - Power Countdown

public struct PowerCountdown: View {
    public let remaining: Double
    public let segments: Int
    public var width: CGFloat

    @State private var startDate = Date.now
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.magiTheme) private var theme

    public init(remaining: Double, segments: Int = 12, width: CGFloat = 300) {
        self.remaining = remaining
        self.segments = segments
        self.width = width
    }

    private var isCritical: Bool { remaining <= 0.2 }

    public var body: some View {
        let intensity = theme.style.glowIntensity

        TimelineView(.animation(minimumInterval: 1.0 / 10, paused: reduceMotion || !isCritical)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let flash = isCritical && !reduceMotion ? sin(elapsed * 6) > 0 : false

            Canvas { context, size in
                let cx = size.width / 2
                drawSegments(context: context, size: size, flash: flash, intensity: intensity)
                drawTimeReadout(context: context, cx: cx, bottom: size.height, flash: flash)
                drawLabel(context: context, cx: cx)
            }
        }
        .frame(width: width, height: 70)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Power remaining: \(Int(remaining * 100)) percent")
    }
}

private extension PowerCountdown {

    func drawSegments(context: GraphicsContext, size: CGSize, flash: Bool, intensity: Double) {
        let clamped = min(max(remaining, 0), 1)
        let filledCount = Int(ceil(clamped * Double(segments)))
        let segW = (size.width - CGFloat(segments - 1) * 2) / CGFloat(segments)
        let segH: CGFloat = 24
        let y: CGFloat = 18

        for i in 0..<segments {
            let x = CGFloat(i) * (segW + 2)
            let rect = CGRect(x: x, y: y, width: segW, height: segH)
            let filled = i < filledCount

            if filled {
                let segColor = segmentColor(index: i)
                let shouldFlash = isCritical && flash && i == filledCount - 1
                let alpha = shouldFlash ? 0.3 : 1.0
                context.fill(Path(rect), with: .color(segColor.opacity(alpha)))

                // Scan lines inside segment
                var scanPath = Path()
                var scanY = y + 2
                while scanY < y + segH {
                    scanPath.addRect(CGRect(x: x + 1, y: scanY, width: segW - 2, height: 1))
                    scanY += 3
                }
                context.fill(scanPath, with: .color(theme.bgPrimary.opacity(0.2)))

                // Glow on filled segments
                if intensity > 0, i >= filledCount - 2 {
                    context.fill(Path(rect), with: .color(segColor.opacity(0.06 * intensity)))
                }
            } else {
                context.fill(Path(rect), with: .color(theme.bgSurface))
            }

            context.stroke(Path(rect), with: .color(theme.border.opacity(filled ? 0.5 : 0.3)), lineWidth: 0.5)
        }
    }

    func segmentColor(index: Int) -> Color {
        let frac = Double(index) / Double(segments)
        if frac < 0.25 { return theme.danger }
        if frac < 0.5 { return theme.accentWarning }
        return theme.accentSuccess
    }

    func drawTimeReadout(context: GraphicsContext, cx: CGFloat, bottom: CGFloat, flash: Bool) {
        let totalSeconds = Int(remaining * 300)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        let timeStr = String(format: "%02d:%02d", minutes, seconds)
        let color = isCritical ? (flash ? theme.danger.opacity(0.4) : theme.danger) : theme.textPrimary
        let timeText = context.resolve(Text(timeStr)
            .font(.system(size: 16, weight: theme.style.headingWeight, design: .monospaced))
            .foregroundColor(color))
        context.draw(timeText, at: CGPoint(x: cx, y: bottom), anchor: .bottom)
    }

    func drawLabel(context: GraphicsContext, cx: CGFloat) {
        let label = context.resolve(Text("INTERNAL POWER")
            .font(.system(size: 8, weight: theme.style.buttonWeight, design: .monospaced))
            .foregroundColor(theme.textMuted))
        context.draw(label, at: CGPoint(x: cx, y: 4), anchor: .top)
    }
}
