import SwiftUI

// MARK: - Shared Input Focus Overlay

private struct InputFocusOverlay: ViewModifier {
    let isFocused: Bool
    @Environment(\.magiTheme) private var theme

    func body(content: Content) -> some View {
        content.overlay {
            Rectangle()
                .stroke(isFocused ? theme.borderFocus : theme.border, lineWidth: theme.style.borderWidth)
        }
    }
}

// MARK: - Text Field

public struct MagiTextField: View {
    public let placeholder: String
    @Binding public var text: String

    @FocusState private var isFocused: Bool
    @Environment(\.magiTheme) private var theme

    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextField("", text: $text, prompt: Text(placeholder.uppercased())
            .font(MagiFont.label)
            .foregroundStyle(theme.textMuted)
        )
        .font(MagiFont.body)
        .foregroundStyle(theme.textPrimary)
        .textFieldStyle(.plain)
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, 6)
        .background(theme.bgSurface)
        .modifier(InputFocusOverlay(isFocused: isFocused))
        .focused($isFocused)
        .accessibilityLabel(placeholder)
    }
}

// MARK: - Command Bar

public struct CommandBar: View {
    @Binding public var text: String

    @FocusState private var isFocused: Bool
    @Environment(\.magiTheme) private var theme

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        HStack(spacing: MagiSpacing.sm) {
            Text(">")
                .font(MagiFont.bodyMedium)
                .foregroundStyle(isFocused ? theme.accent : theme.textMuted)

            TextField("", text: $text, prompt: Text("COMMAND")
                .font(MagiFont.label)
                .foregroundStyle(theme.textMuted)
            )
            .font(MagiFont.body)
            .foregroundStyle(theme.textPrimary)
            .textFieldStyle(.plain)
            .focused($isFocused)
        }
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, MagiSpacing.sm)
        .background(theme.bgSurface)
        .modifier(InputFocusOverlay(isFocused: isFocused))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Command bar")
    }
}
