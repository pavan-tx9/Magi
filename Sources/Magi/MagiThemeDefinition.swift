import SwiftUI

// MARK: - Component Shape Enums

public enum MagiPanelShape: Sendable {
    case rectangle
    case chamfer
}

// MARK: - Style Properties

public struct MagiStyle: Sendable, Equatable {
    public let borderWidth: CGFloat
    public let panelShape: MagiPanelShape
    public let chamferCut: CGFloat
    public let buttonFillOnHover: Bool
    public let buttonWeight: Font.Weight
    public let glowIntensity: Double
    public let scanLineSpacing: CGFloat
    public let showDecorations: Bool
    public let statusPulse: Bool
    public let labelTracking: CGFloat
    public let headingWeight: Font.Weight
    public let activeIndicatorWidth: CGFloat
    public let modalAccentLine: Bool
    public let modalAccentLineHeight: CGFloat

    public init(
        borderWidth: CGFloat = 1,
        panelShape: MagiPanelShape = .chamfer,
        chamferCut: CGFloat = 10,
        buttonFillOnHover: Bool = false,
        buttonWeight: Font.Weight = .medium,
        glowIntensity: Double = 1.0,
        scanLineSpacing: CGFloat = 3,
        showDecorations: Bool = true,
        statusPulse: Bool = true,
        labelTracking: CGFloat = 1.5,
        headingWeight: Font.Weight = .semibold,
        activeIndicatorWidth: CGFloat = 2,
        modalAccentLine: Bool = true,
        modalAccentLineHeight: CGFloat = 2
    ) {
        self.borderWidth = borderWidth
        self.panelShape = panelShape
        self.chamferCut = chamferCut
        self.buttonFillOnHover = buttonFillOnHover
        self.buttonWeight = buttonWeight
        self.glowIntensity = glowIntensity
        self.scanLineSpacing = scanLineSpacing
        self.showDecorations = showDecorations
        self.statusPulse = statusPulse
        self.labelTracking = labelTracking
        self.headingWeight = headingWeight
        self.activeIndicatorWidth = activeIndicatorWidth
        self.modalAccentLine = modalAccentLine
        self.modalAccentLineHeight = modalAccentLineHeight
    }
}

// MARK: - Theme

public struct MagiTheme: Sendable, Equatable {
    public let bgPrimary: Color
    public let bgSecondary: Color
    public let bgSurface: Color
    public let border: Color
    public let borderFocus: Color
    public let textPrimary: Color
    public let textMuted: Color
    public let accent: Color
    public let accentSecondary: Color
    public let accentWarning: Color
    public let accentSuccess: Color
    public let danger: Color
    public let glowRadius: CGFloat
    public let scanLineOpacity: Double
    public let style: MagiStyle

    public init(
        bgPrimary: Color, bgSecondary: Color, bgSurface: Color,
        border: Color, borderFocus: Color,
        textPrimary: Color, textMuted: Color,
        accent: Color, accentSecondary: Color,
        accentWarning: Color, accentSuccess: Color, danger: Color,
        glowRadius: CGFloat, scanLineOpacity: Double,
        style: MagiStyle = MagiStyle()
    ) {
        self.bgPrimary = bgPrimary
        self.bgSecondary = bgSecondary
        self.bgSurface = bgSurface
        self.border = border
        self.borderFocus = borderFocus
        self.textPrimary = textPrimary
        self.textMuted = textMuted
        self.accent = accent
        self.accentSecondary = accentSecondary
        self.accentWarning = accentWarning
        self.accentSuccess = accentSuccess
        self.danger = danger
        self.glowRadius = glowRadius
        self.scanLineOpacity = scanLineOpacity
        self.style = style
    }

    // Theme-aware fonts that respect style weights
    public var headingFont: Font {
        .system(size: 15, weight: style.headingWeight, design: .monospaced)
    }
    public var headingLargeFont: Font {
        .system(size: 18, weight: style.headingWeight, design: .monospaced)
    }
    public var buttonFont: Font {
        .system(size: 11, weight: style.buttonWeight, design: .monospaced)
    }
}

// MARK: - Environment

private struct MagiThemeKey: EnvironmentKey {
    static let defaultValue: MagiTheme = .nerv
}

public extension EnvironmentValues {
    var magiTheme: MagiTheme {
        get { self[MagiThemeKey.self] }
        set { self[MagiThemeKey.self] = newValue }
    }
}

public extension View {
    func magiTheme(_ theme: MagiTheme) -> some View {
        environment(\.magiTheme, theme)
    }
}
