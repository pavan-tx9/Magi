import SwiftUI

// MARK: - Status Badge

public enum OperationStatus: String {
    case nominal = "NOMINAL"
    case pending = "PENDING"
    case overdue = "OVERDUE"
    case complete = "COMPLETE"

    public var color: Color {
        switch self {
        case .nominal: return MagiColor.accentCyan
        case .pending: return MagiColor.accentAmber
        case .overdue: return MagiColor.danger
        case .complete: return MagiColor.accentGreen
        }
    }
}

public struct StatusBadge: View {
    public let status: OperationStatus

    @State private var glowOpacity: Double = 0.3
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(status: OperationStatus) {
        self.status = status
    }

    public var body: some View {
        Text(status.rawValue)
            .font(MagiFont.tiny)
            .tracking(1.5)
            .foregroundStyle(status.color)
            .shadow(
                color: status == .overdue ? status.color.opacity(glowOpacity) : .clear,
                radius: 8
            )
            .onAppear {
                guard status == .overdue, !reduceMotion else { return }
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
    public var color: Color
    @Environment(\.colorSchemeContrast) private var contrast

    public init(label: String, color: Color = MagiColor.textMuted) {
        self.label = label
        self.color = color
    }

    public var body: some View {
        Text(label.uppercased())
            .font(MagiFont.tiny)
            .tracking(1)
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .overlay {
                Rectangle()
                    .stroke(color.opacity(contrast == .increased ? 0.8 : 0.4), lineWidth: 1)
            }
            .accessibilityLabel("Tag: \(label)")
    }
}

// MARK: - Key Command Hint

public struct KeyHint: View {
    public let keys: [String]

    public init(keys: [String]) {
        self.keys = keys
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(MagiColor.textMuted)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(MagiColor.bgSurface)
                    .overlay {
                        Rectangle()
                            .stroke(MagiColor.border, lineWidth: 1)
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
    public var color: Color
    public var height: CGFloat

    public init(value: Double, color: Color = MagiColor.accentRed, height: CGFloat = 4) {
        self.value = value
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(MagiColor.bgSurface)

                Rectangle()
                    .fill(color)
                    .frame(width: geo.size.width * min(max(value, 0), 1))

                Rectangle()
                    .stroke(MagiColor.border, lineWidth: 1)
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(min(max(value, 0), 1) * 100)) percent")
    }
}
