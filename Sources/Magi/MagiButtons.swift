import SwiftUI

public struct MagiButton: View {
    public let label: String
    public let action: () -> Void
    public var accent: Color

    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    public init(label: String, action: @escaping () -> Void, accent: Color = MagiColor.border) {
        self.label = label
        self.action = action
        self.accent = accent
    }

    public var body: some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(MagiFont.label)
                .tracking(1)
                .foregroundStyle((isHovered || isFocused) ? MagiColor.accentRed : MagiColor.textPrimary)
                .padding(.horizontal, MagiSpacing.md)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
                .overlay {
                    Rectangle()
                        .stroke((isHovered || isFocused) ? MagiColor.accentRed : accent, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(label)
    }
}

public struct MagiChamferButton: View {
    public let label: String
    public let action: () -> Void

    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    public init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(MagiFont.label)
                .tracking(1)
                .foregroundStyle((isHovered || isFocused) ? MagiColor.accentRed : MagiColor.textPrimary)
                .padding(.horizontal, MagiSpacing.lg)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
                .background {
                    ChamferShape(cut: 6)
                        .stroke((isHovered || isFocused) ? MagiColor.accentRed : MagiColor.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(label)
    }
}

public struct MagiIconButton: View {
    public let symbol: String
    public let action: () -> Void

    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    public init(symbol: String, action: @escaping () -> Void) {
        self.symbol = symbol
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle((isHovered || isFocused) ? MagiColor.accentRed : MagiColor.textMuted)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
                .overlay {
                    Rectangle()
                        .stroke((isHovered || isFocused) ? MagiColor.accentRed : MagiColor.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(symbol)
    }
}
