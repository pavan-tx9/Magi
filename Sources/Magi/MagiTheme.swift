import SwiftUI

@available(*, deprecated, message: "Use @Environment(\\.magiTheme) instead — MagiColor is hardwired to NERV and ignores the active theme")
public enum MagiColor {
    public static let bgPrimary = MagiTheme.nerv.bgPrimary
    public static let bgSecondary = MagiTheme.nerv.bgSecondary
    public static let bgSurface = MagiTheme.nerv.bgSurface
    public static let border = MagiTheme.nerv.border
    public static let borderFocus = MagiTheme.nerv.borderFocus
    public static let textPrimary = MagiTheme.nerv.textPrimary
    public static let textMuted = MagiTheme.nerv.textMuted
    public static let accentRed = MagiTheme.nerv.accent
    public static let accentAmber = MagiTheme.nerv.accentWarning
    public static let accentGreen = MagiTheme.nerv.accentSuccess
    public static let accentCyan = MagiTheme.nerv.accentSecondary
    public static let danger = MagiTheme.nerv.danger
}

public enum MagiFont {
    public static let body = Font.system(size: 13, design: .monospaced)
    public static let bodyMedium = Font.system(size: 13, weight: .medium, design: .monospaced)
    public static let label = Font.system(size: 11, weight: .medium, design: .monospaced)
    public static let heading = Font.system(size: 15, weight: .semibold, design: .monospaced)
    public static let headingLarge = Font.system(size: 18, weight: .semibold, design: .monospaced)
    public static let tiny = Font.system(size: 10, weight: .medium, design: .monospaced)
}

public enum MagiSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
}

public extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

public struct ChamferShape: Shape {
    public let cut: CGFloat

    public init(cut: CGFloat) {
        self.cut = cut
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + cut, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cut, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cut))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cut))
        path.addLine(to: CGPoint(x: rect.maxX - cut, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cut, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cut))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cut))
        path.closeSubpath()
        return path
    }
}

public struct ScanLinesOverlay: View {
    @Environment(\.magiTheme) private var theme

    public init() {}

    public var body: some View {
        Canvas { context, size in
            let lineSpacing = theme.style.scanLineSpacing
            guard lineSpacing > 0 else { return }
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                context.fill(Path(rect), with: .color(.black.opacity(theme.scanLineOpacity)))
                y += lineSpacing
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

public struct Arc: Shape {
    public let startAngle: Angle
    public let endAngle: Angle

    public init(startAngle: Angle, endAngle: Angle) {
        self.startAngle = startAngle
        self.endAngle = endAngle
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle,
                    clockwise: false)
        return path
    }
}
