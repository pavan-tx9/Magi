import SwiftUI

// MARK: - Task Row

public enum MagiPriority {
    case none
    case normal
    case dueSoon
    case overdue
    case done

    public var barColor: Color? {
        switch self {
        case .none, .normal: return nil
        case .dueSoon: return MagiColor.accentAmber
        case .overdue: return MagiColor.danger
        case .done: return MagiColor.accentGreen
        }
    }
}

public struct TaskRow: View {
    public let title: String
    public let metadata: String
    public let priority: MagiPriority
    public var tags: [String]

    @State private var isHovered = false

    private var isDone: Bool { priority == .done }

    public init(title: String, metadata: String, priority: MagiPriority, tags: [String] = []) {
        self.title = title
        self.metadata = metadata
        self.priority = priority
        self.tags = tags
    }

    public var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(priority.barColor ?? .clear)
                .frame(width: 2)

            HStack(spacing: MagiSpacing.sm) {
                Text(title)
                    .font(MagiFont.body)
                    .foregroundStyle(isDone ? MagiColor.textMuted : MagiColor.textPrimary)
                    .strikethrough(isDone, color: MagiColor.textMuted)
                    .lineLimit(1)

                Spacer()

                ForEach(tags, id: \.self) { tag in
                    MagiTag(label: tag, color: MagiColor.accentCyan)
                }

                Text(metadata.uppercased())
                    .font(MagiFont.tiny)
                    .tracking(0.8)
                    .foregroundStyle(MagiColor.textMuted)
            }
            .padding(.horizontal, MagiSpacing.md)
            .padding(.vertical, 6)
        }
        .frame(height: 32)
        .background(isHovered ? MagiColor.bgSurface : MagiColor.bgSecondary)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Data Readout

public struct DataReadout: View {
    public let label: String
    public let value: String
    public var color: Color

    public init(label: String, value: String, color: Color = MagiColor.textPrimary) {
        self.label = label
        self.value = value
        self.color = color
    }

    public var body: some View {
        HStack(spacing: MagiSpacing.sm) {
            Text(label.uppercased())
                .font(MagiFont.tiny)
                .tracking(1.5)
                .foregroundStyle(MagiColor.textMuted)
                .frame(width: 80, alignment: .leading)

            Rectangle()
                .fill(MagiColor.border)
                .frame(width: 1, height: 12)

            Text(value)
                .font(MagiFont.body)
                .foregroundStyle(color)
        }
    }
}

// MARK: - Alert Banner

public enum AlertLevel {
    case info
    case warning
    case critical

    public var color: Color {
        switch self {
        case .info: return MagiColor.accentCyan
        case .warning: return MagiColor.accentAmber
        case .critical: return MagiColor.danger
        }
    }

    public var prefix: String {
        switch self {
        case .info: return "INFO"
        case .warning: return "WARN"
        case .critical: return "CRIT"
        }
    }
}

public struct AlertBanner: View {
    public let level: AlertLevel
    public let message: String

    public init(level: AlertLevel, message: String) {
        self.level = level
        self.message = message
    }

    public var body: some View {
        HStack(spacing: MagiSpacing.sm) {
            Rectangle()
                .fill(level.color)
                .frame(width: 3)

            Text(level.prefix)
                .font(MagiFont.tiny)
                .tracking(1.5)
                .foregroundStyle(level.color)

            Text(message)
                .font(MagiFont.body)
                .foregroundStyle(MagiColor.textPrimary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.trailing, MagiSpacing.md)
        .background(level.color.opacity(0.06))
        .overlay {
            Rectangle()
                .stroke(level.color.opacity(0.2), lineWidth: 1)
        }
    }
}

// MARK: - Sidebar Item

public struct SidebarItem: View {
    public let label: String
    public let isActive: Bool
    public var count: Int?

    @State private var isHovered = false

    public init(label: String, isActive: Bool, count: Int? = nil) {
        self.label = label
        self.isActive = isActive
        self.count = count
    }

    public var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(isActive ? MagiColor.accentRed : .clear)
                .frame(width: 2)

            HStack {
                Text(label)
                    .font(MagiFont.body)
                    .foregroundStyle(
                        isActive ? MagiColor.textPrimary :
                        isHovered ? MagiColor.textPrimary : MagiColor.textMuted
                    )

                Spacer()

                if let count {
                    Text("\(count)")
                        .font(MagiFont.tiny)
                        .foregroundStyle(MagiColor.textMuted)
                }
            }
            .padding(.horizontal, MagiSpacing.md)
            .padding(.vertical, 6)
        }
        .background(isHovered ? MagiColor.bgSurface : .clear)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Section Header

public struct SectionHeader: View {
    public let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.xs) {
            Text(title.uppercased())
                .font(MagiFont.tiny)
                .tracking(2)
                .foregroundStyle(MagiColor.textMuted)

            Rectangle()
                .fill(MagiColor.border)
                .frame(height: 1)
        }
    }
}

// MARK: - Divider

public struct MagiDivider: View {
    public init() {}

    public var body: some View {
        Rectangle()
            .fill(MagiColor.border)
            .frame(height: 1)
    }
}
