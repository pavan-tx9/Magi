import SwiftUI

// MARK: - Shared Button Border Overlay

private struct ButtonBorderOverlay: ViewModifier {
    let active: Bool
    let inactiveColor: Color
    @Environment(\.magiTheme) private var theme

    func body(content: Content) -> some View {
        content.overlay {
            Rectangle()
                .stroke(active ? theme.accent : inactiveColor, lineWidth: theme.style.borderWidth)
        }
    }
}

// MARK: - Button

public struct MagiButton: View {
    public let label: String
    public let action: () -> Void
    public var accent: Color?

    @State private var isHovered = false
    @FocusState private var isFocused: Bool
    @Environment(\.magiTheme) private var theme

    public init(label: String, action: @escaping () -> Void, accent: Color? = nil) {
        self.label = label
        self.action = action
        self.accent = accent
    }

    public var body: some View {
        let active = isHovered || isFocused
        let s = theme.style
        Button(action: action) {
            Text(label.uppercased())
                .font(theme.buttonFont)
                .tracking(s.labelTracking)
                .foregroundStyle(active ? theme.accent : theme.textPrimary)
                .padding(.horizontal, MagiSpacing.md)
                .padding(.vertical, MagiSpacing.sm)
                .contentShape(Rectangle())
                .background {
                    if s.buttonFillOnHover, active {
                        Rectangle().fill(theme.accent.opacity(0.15))
                    }
                }
                .modifier(ButtonBorderOverlay(active: active, inactiveColor: accent ?? theme.border))
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(label)
    }
}

// MARK: - Chamfer Button

public struct MagiChamferButton: View {
    public let label: String
    public let action: () -> Void

    @State private var isHovered = false
    @FocusState private var isFocused: Bool
    @Environment(\.magiTheme) private var theme

    public init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        let active = isHovered || isFocused
        let s = theme.style
        let cut = max(s.chamferCut, 6)
        Button(action: action) {
            Text(label.uppercased())
                .font(theme.buttonFont)
                .tracking(s.labelTracking)
                .foregroundStyle(active ? theme.accent : theme.textPrimary)
                .padding(.horizontal, MagiSpacing.lg)
                .padding(.vertical, MagiSpacing.sm)
                .contentShape(Rectangle())
                .background {
                    if s.buttonFillOnHover, active {
                        ChamferShape(cut: cut).fill(theme.accent.opacity(0.15))
                    }
                }
                .background {
                    ChamferShape(cut: cut)
                        .stroke(active ? theme.accent : theme.border, lineWidth: s.borderWidth)
                }
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(label)
    }
}

// MARK: - Icon Button

public struct MagiIconButton: View {
    public let symbol: String
    public let action: () -> Void

    @State private var isHovered = false
    @FocusState private var isFocused: Bool
    @Environment(\.magiTheme) private var theme

    public init(symbol: String, action: @escaping () -> Void) {
        self.symbol = symbol
        self.action = action
    }

    public var body: some View {
        let active = isHovered || isFocused
        let s = theme.style
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: s.buttonWeight))
                .foregroundStyle(active ? theme.accent : theme.textMuted)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
                .background {
                    if s.buttonFillOnHover, active {
                        Rectangle().fill(theme.accent.opacity(0.15))
                    }
                }
                .modifier(ButtonBorderOverlay(active: active, inactiveColor: theme.border))
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .onHover { isHovered = $0 }
        .accessibilityLabel(symbol)
    }
}
