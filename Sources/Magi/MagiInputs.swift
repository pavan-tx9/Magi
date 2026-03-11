import SwiftUI

public struct MagiTextField: View {
    public let placeholder: String
    @Binding public var text: String

    @FocusState private var isFocused: Bool

    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextField("", text: $text, prompt: Text(placeholder.uppercased())
            .font(MagiFont.label)
            .foregroundStyle(MagiColor.textMuted)
        )
        .font(MagiFont.body)
        .foregroundStyle(MagiColor.textPrimary)
        .textFieldStyle(.plain)
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, 6)
        .background(MagiColor.bgSurface)
        .overlay {
            Rectangle()
                .stroke(isFocused ? MagiColor.borderFocus : MagiColor.border, lineWidth: 1)
        }
        .focused($isFocused)
    }
}

public struct CommandBar: View {
    @Binding public var text: String

    @FocusState private var isFocused: Bool

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        HStack(spacing: MagiSpacing.sm) {
            Text(">")
                .font(MagiFont.bodyMedium)
                .foregroundStyle(isFocused ? MagiColor.accentRed : MagiColor.textMuted)

            TextField("", text: $text, prompt: Text("COMMAND")
                .font(MagiFont.label)
                .foregroundStyle(MagiColor.textMuted)
            )
            .font(MagiFont.body)
            .foregroundStyle(MagiColor.textPrimary)
            .textFieldStyle(.plain)
            .focused($isFocused)
        }
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, MagiSpacing.sm)
        .background(MagiColor.bgSurface)
        .overlay {
            Rectangle()
                .stroke(isFocused ? MagiColor.borderFocus : MagiColor.border, lineWidth: 1)
        }
    }
}
