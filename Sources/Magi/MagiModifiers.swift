import SwiftUI

// MARK: - Window Styling

public extension View {

    func magiWindow() -> some View {
        self
            .background(MagiColor.bgPrimary)
            .foregroundStyle(MagiColor.textPrimary)
            .font(MagiFont.body)
            .overlay { ScanLinesOverlay() }
    }

    func magiPanel() -> some View {
        self
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
    }

    func magiPanel(accent: Color) -> some View {
        self
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(accent.opacity(0.3), lineWidth: 1) }
    }

    func magiChamferPanel(cut: CGFloat = 10) -> some View {
        self
            .background { ChamferShape(cut: cut).fill(MagiColor.bgSecondary) }
            .overlay { ChamferShape(cut: cut).stroke(MagiColor.border, lineWidth: 1) }
    }

    func magiChamferPanel(cut: CGFloat = 10, accent: Color) -> some View {
        self
            .background { ChamferShape(cut: cut).fill(MagiColor.bgSecondary) }
            .overlay { ChamferShape(cut: cut).stroke(accent.opacity(0.3), lineWidth: 1) }
    }

    func magiSurface() -> some View {
        self.background(MagiColor.bgSurface)
    }
}

// MARK: - Text Styling

public extension Text {

    func magiLabel() -> some View {
        self
            .font(MagiFont.tiny)
            .tracking(1.5)
            .foregroundStyle(MagiColor.textMuted)
    }

    func magiLabelWide() -> some View {
        self
            .font(MagiFont.tiny)
            .tracking(2)
            .foregroundStyle(MagiColor.textMuted)
    }

    func magiHeading() -> some View {
        self
            .font(MagiFont.heading)
            .foregroundStyle(MagiColor.textPrimary)
    }

    func magiHeadingLarge() -> some View {
        self
            .font(MagiFont.headingLarge)
            .foregroundStyle(MagiColor.textPrimary)
    }

    func magiBody() -> some View {
        self
            .font(MagiFont.body)
            .foregroundStyle(MagiColor.textPrimary)
    }

    func magiBodyMuted() -> some View {
        self
            .font(MagiFont.body)
            .foregroundStyle(MagiColor.textMuted)
    }
}
