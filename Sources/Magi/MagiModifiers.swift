import SwiftUI

// MARK: - Window Styling

private struct MagiWindowModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme

    func body(content: Content) -> some View {
        content
            .textSelection(.enabled)
            .background(theme.bgPrimary)
            .foregroundStyle(theme.textPrimary)
            .font(MagiFont.body)
            .overlay { ScanLinesOverlay() }
    }
}

private struct MagiPanelModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    let accent: Color?

    func body(content: Content) -> some View {
        let s = theme.style
        let strokeColor = accent.map { $0.opacity(0.3) } ?? theme.border
        switch s.panelShape {
        case .rectangle:
            content
                .background(theme.bgSecondary)
                .overlay { Rectangle().stroke(strokeColor, lineWidth: s.borderWidth) }
        case .chamfer:
            content
                .background { ChamferShape(cut: s.chamferCut).fill(theme.bgSecondary) }
                .overlay { ChamferShape(cut: s.chamferCut).stroke(strokeColor, lineWidth: s.borderWidth) }
        }
    }
}

private struct MagiChamferPanelModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    let cut: CGFloat
    let accent: Color?

    func body(content: Content) -> some View {
        let strokeColor = accent.map { $0.opacity(0.3) } ?? theme.border
        content
            .background { ChamferShape(cut: cut).fill(theme.bgSecondary) }
            .overlay { ChamferShape(cut: cut).stroke(strokeColor, lineWidth: theme.style.borderWidth) }
    }
}

private struct MagiSurfaceModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme

    func body(content: Content) -> some View {
        content.background(theme.bgSurface)
    }
}

public extension View {
    func magiWindow() -> some View { modifier(MagiWindowModifier()) }
    func magiPanel() -> some View { modifier(MagiPanelModifier(accent: nil)) }
    func magiPanel(accent: Color) -> some View { modifier(MagiPanelModifier(accent: accent)) }
    func magiChamferPanel(cut: CGFloat = 10) -> some View { modifier(MagiChamferPanelModifier(cut: cut, accent: nil)) }
    func magiChamferPanel(cut: CGFloat = 10, accent: Color) -> some View {
        modifier(MagiChamferPanelModifier(cut: cut, accent: accent))
    }
    func magiSurface() -> some View { modifier(MagiSurfaceModifier()) }
}

// MARK: - Text Styling

private struct MagiLabelModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(MagiFont.tiny).tracking(theme.style.labelTracking).foregroundStyle(theme.textMuted)
    }
}

private struct MagiLabelWideModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(MagiFont.tiny).tracking(theme.style.labelTracking + 0.5).foregroundStyle(theme.textMuted)
    }
}

private struct MagiHeadingModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(theme.headingFont).foregroundStyle(theme.textPrimary)
    }
}

private struct MagiHeadingLargeModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(theme.headingLargeFont).foregroundStyle(theme.textPrimary)
    }
}

private struct MagiBodyModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(MagiFont.body).foregroundStyle(theme.textPrimary)
    }
}

private struct MagiBodyMutedModifier: ViewModifier {
    @Environment(\.magiTheme) private var theme
    func body(content: Content) -> some View {
        content.font(MagiFont.body).foregroundStyle(theme.textMuted)
    }
}

public extension Text {
    func magiLabel() -> some View { modifier(MagiLabelModifier()) }
    func magiLabelWide() -> some View { modifier(MagiLabelWideModifier()) }
    func magiHeading() -> some View { modifier(MagiHeadingModifier()) }
    func magiHeadingLarge() -> some View { modifier(MagiHeadingLargeModifier()) }
    func magiBody() -> some View { modifier(MagiBodyModifier()) }
    func magiBodyMuted() -> some View { modifier(MagiBodyMutedModifier()) }
}
