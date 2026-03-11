import SwiftUI

public struct GlowText: View {
    public let text: String
    public var font: Font
    public var color: Color

    public init(text: String, font: Font = MagiFont.heading, color: Color = MagiColor.accentRed) {
        self.text = text
        self.font = font
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(color)
            .shadow(color: color.opacity(0.3), radius: 8)
            .shadow(color: color.opacity(0.15), radius: 16)
    }
}

public struct BlinkingCursor: View {
    @State private var visible = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(MagiColor.accentRed)
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
