import SwiftUI

public struct GlowText: View {
    public let text: String
    public var font: Font
    public var color: Color?

    @Environment(\.magiTheme) private var theme

    public init(text: String, font: Font = MagiFont.heading, color: Color? = nil) {
        self.text = text
        self.font = font
        self.color = color
    }

    public var body: some View {
        let resolved = color ?? theme.accent
        let intensity = theme.style.glowIntensity
        Text(text)
            .font(font)
            .foregroundStyle(resolved)
            .shadow(
                color: intensity > 0 ? resolved.opacity(0.3 * intensity) : .clear,
                radius: theme.glowRadius
            )
            .shadow(
                color: intensity > 0 ? resolved.opacity(0.15 * intensity) : .clear,
                radius: theme.glowRadius * 2
            )
            .accessibilityLabel(text)
    }
}

public struct BlinkingCursor: View {
    @State private var visible = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(theme.accent)
            .frame(width: 2, height: 14)
            .opacity(visible ? 1 : 0)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
            .accessibilityHidden(true)
    }
}
