import SwiftUI

public enum MagiColor {
    public static let bgPrimary = Color(hex: 0x0A0A0A)
    public static let bgSecondary = Color(hex: 0x141414)
    public static let bgSurface = Color(hex: 0x1A1A1A)
    public static let border = Color(hex: 0x2A2A2A)
    public static let borderFocus = Color(hex: 0xCC0000)
    public static let textPrimary = Color(hex: 0xE0E0E0)
    public static let textMuted = Color(hex: 0x707070)
    public static let accentRed = Color(hex: 0xCC0000)
    public static let accentAmber = Color(hex: 0xCC8800)
    public static let accentGreen = Color(hex: 0x00AA66)
    public static let accentCyan = Color(hex: 0x00AAAA)
    public static let danger = Color(hex: 0xFF3333)
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
    public init() {}

    public var body: some View {
        Canvas { context, size in
            let lineSpacing: CGFloat = 3
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                context.fill(Path(rect), with: .color(.black.opacity(0.08)))
                y += lineSpacing
            }
        }
        .allowsHitTesting(false)
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
