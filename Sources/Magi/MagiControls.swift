import SwiftUI

public struct MagiToggle: View {
    @Binding public var isOn: Bool
    public var label: String?

    @State private var isHovered = false
    @Environment(\.magiTheme) private var theme

    public init(isOn: Binding<Bool>, label: String? = nil) {
        self._isOn = isOn
        self.label = label
    }

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: MagiSpacing.sm) {
                toggleVisual

                if let label {
                    Text(label)
                        .font(MagiFont.body)
                        .foregroundStyle(isOn ? theme.textPrimary : theme.textMuted)
                }
            }
            .padding(.vertical, MagiSpacing.xs)
            .padding(.horizontal, MagiSpacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Toggle")
        .accessibilityValue(isOn ? "on" : "off")
        .accessibilityAddTraits(.isToggle)
    }

    private var toggleVisual: some View {
        let bw = theme.style.borderWidth
        return HStack(spacing: 0) {
            Rectangle()
                .fill(isOn ? theme.accent : theme.bgSurface)
                .frame(width: 18, height: 14)
                .overlay {
                    if isOn {
                        Text("I")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(theme.textPrimary)
                    }
                }
            Rectangle()
                .fill(isOn ? theme.bgSurface : theme.textMuted.opacity(0.3))
                .frame(width: 18, height: 14)
                .overlay {
                    if !isOn {
                        Text("O")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(theme.textMuted)
                    }
                }
        }
        .overlay {
            Rectangle()
                .stroke(isHovered ? theme.accent : (isOn ? theme.accent : theme.border), lineWidth: bw)
        }
    }
}

public struct MagiCheckbox: View {
    @Binding public var isChecked: Bool
    public var label: String?

    @State private var isHovered = false
    @Environment(\.magiTheme) private var theme

    public init(isChecked: Binding<Bool>, label: String? = nil) {
        self._isChecked = isChecked
        self.label = label
    }

    public var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack(spacing: MagiSpacing.sm) {
                checkboxVisual

                if let label {
                    Text(label)
                        .font(MagiFont.body)
                        .foregroundStyle(isChecked ? theme.textPrimary : theme.textMuted)
                }
            }
            .padding(.vertical, MagiSpacing.xs)
            .padding(.horizontal, MagiSpacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Checkbox")
        .accessibilityValue(isChecked ? "checked" : "unchecked")
        .accessibilityAddTraits(.isToggle)
    }

    private var checkboxVisual: some View {
        let bw = theme.style.borderWidth
        return Rectangle()
            .fill(isChecked ? theme.accent : .clear)
            .frame(width: 14, height: 14)
            .overlay {
                Rectangle()
                    .stroke(isHovered ? theme.accent : (isChecked ? theme.accent : theme.textMuted), lineWidth: bw)
            }
            .overlay {
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(theme.textPrimary)
                }
            }
    }
}
