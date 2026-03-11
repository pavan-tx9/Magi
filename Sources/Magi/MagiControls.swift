import SwiftUI

public struct MagiToggle: View {
    @Binding public var isOn: Bool
    public var label: String?

    @State private var isHovered = false

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
                        .foregroundStyle(isOn ? MagiColor.textPrimary : MagiColor.textMuted)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }

    private var toggleVisual: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(isOn ? MagiColor.accentRed : MagiColor.bgSurface)
                .frame(width: 18, height: 14)
                .overlay {
                    if isOn {
                        Text("I")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(MagiColor.textPrimary)
                    }
                }

            Rectangle()
                .fill(isOn ? MagiColor.bgSurface : MagiColor.textMuted.opacity(0.3))
                .frame(width: 18, height: 14)
                .overlay {
                    if !isOn {
                        Text("O")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(MagiColor.textMuted)
                    }
                }
        }
        .overlay {
            Rectangle()
                .stroke(isHovered ? MagiColor.accentRed : (isOn ? MagiColor.accentRed : MagiColor.border), lineWidth: 1)
        }
    }
}

public struct MagiCheckbox: View {
    @Binding public var isChecked: Bool
    public var label: String?

    @State private var isHovered = false

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
                        .foregroundStyle(isChecked ? MagiColor.textPrimary : MagiColor.textMuted)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }

    private var checkboxVisual: some View {
        Rectangle()
            .fill(isChecked ? MagiColor.accentRed : .clear)
            .frame(width: 14, height: 14)
            .overlay {
                Rectangle()
                    .stroke(isHovered ? MagiColor.accentRed : (isChecked ? MagiColor.accentRed : MagiColor.textMuted), lineWidth: 1)
            }
            .overlay {
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(MagiColor.textPrimary)
                }
            }
    }
}
