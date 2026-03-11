import SwiftUI

// MARK: - Status Badge

public enum OperationStatus: String {
    case nominal = "NOMINAL"
    case pending = "PENDING"
    case overdue = "OVERDUE"
    case complete = "COMPLETE"

    public func color(in theme: MagiTheme) -> Color {
        switch self {
        case .nominal: return theme.accentSecondary
        case .pending: return theme.accentWarning
        case .overdue: return theme.danger
        case .complete: return theme.accentSuccess
        }
    }
}

public struct StatusBadge: View {
    public let status: OperationStatus

    @State private var glowOpacity: Double = 0.3
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.magiTheme) private var theme

    public init(status: OperationStatus) {
        self.status = status
    }

    public var body: some View {
        let statusColor = status.color(in: theme)
        let intensity = theme.style.glowIntensity
        Text(status.rawValue)
            .font(MagiFont.tiny)
            .tracking(theme.style.labelTracking)
            .foregroundStyle(statusColor)
            .shadow(
                color: status == .overdue && intensity > 0 ? statusColor.opacity(glowOpacity * intensity) : .clear,
                radius: theme.glowRadius
            )
            .onAppear {
                guard status == .overdue, !reduceMotion, theme.style.statusPulse else { return }
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    glowOpacity = 0.8
                }
            }
            .accessibilityLabel("Status: \(status.rawValue.lowercased())")
    }
}

// MARK: - Tag

public struct MagiTag: View {
    public let label: String
    public var color: Color?
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.magiTheme) private var theme

    public init(label: String, color: Color? = nil) {
        self.label = label
        self.color = color
    }

    public var body: some View {
        let resolved = color ?? theme.textMuted
        Text(label.uppercased())
            .font(MagiFont.tiny)
            .tracking(theme.style.labelTracking - 0.5)
            .foregroundStyle(resolved)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .overlay {
                Rectangle()
                    .stroke(resolved.opacity(contrast == .increased ? 0.8 : 0.4), lineWidth: theme.style.borderWidth)
            }
            .accessibilityLabel("Tag: \(label)")
    }
}

// MARK: - Key Command Hint

public struct KeyHint: View {
    public let keys: [String]
    @Environment(\.magiTheme) private var theme

    public init(keys: [String]) {
        self.keys = keys
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(.system(size: 10, weight: theme.style.buttonWeight, design: .monospaced))
                    .foregroundStyle(theme.textMuted)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(theme.bgSurface)
                    .overlay {
                        Rectangle()
                            .stroke(theme.border, lineWidth: theme.style.borderWidth)
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(keys.joined(separator: " "))
    }
}

// MARK: - Progress Bar

public struct MagiProgress: View {
    public let value: Double
    public var color: Color?
    public var height: CGFloat

    @Environment(\.magiTheme) private var theme

    public init(value: Double, color: Color? = nil, height: CGFloat = 4) {
        self.value = value
        self.color = color
        self.height = height
    }

    public var body: some View {
        let resolved = color ?? theme.accent
        let clamped = min(max(value, 0), 1)
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(theme.bgSurface)
                Rectangle().fill(resolved).frame(width: geo.size.width * clamped)
                Rectangle().stroke(theme.border, lineWidth: theme.style.borderWidth)
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(clamped * 100)) percent")
    }
}
