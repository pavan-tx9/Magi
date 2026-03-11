import SwiftUI

// MARK: - Task Row
public enum MagiPriority {
    case none, normal, dueSoon, overdue, done

    public func barColor(in theme: MagiTheme) -> Color? {
        switch self {
        case .none, .normal: return nil
        case .dueSoon: return theme.accentWarning
        case .overdue: return theme.danger
        case .done: return theme.accentSuccess
        }
    }

    public var accessibilityDescription: String {
        switch self {
        case .none: return ""
        case .normal: return "normal priority"
        case .dueSoon: return "due soon"
        case .overdue: return "overdue"
        case .done: return "completed"
        }
    }

    public var symbolPrefix: String? {
        switch self {
        case .none, .normal: return nil
        case .dueSoon: return "[!]"
        case .overdue: return "[!!]"
        case .done: return "[OK]"
        }
    }
}

public struct TaskRow: View {
    public let title: String
    public let metadata: String
    public let priority: MagiPriority
    public var tags: [String]
    @State private var isHovered = false
    @Environment(\.accessibilityDifferentiateWithoutColor) private var diffWithoutColor
    @Environment(\.magiTheme) private var theme
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
                .fill(priority.barColor(in: theme) ?? .clear)
                .frame(width: theme.style.activeIndicatorWidth)

            HStack(spacing: MagiSpacing.sm) {
                if diffWithoutColor, let prefix = priority.symbolPrefix {
                    Text(prefix)
                        .font(MagiFont.tiny)
                        .foregroundStyle(priority.barColor(in: theme) ?? theme.textMuted)
                }
                Text(title)
                    .font(MagiFont.body)
                    .foregroundStyle(isDone ? theme.textMuted : theme.textPrimary)
                    .strikethrough(isDone, color: theme.textMuted)
                    .lineLimit(1)
                Spacer()
                ForEach(tags, id: \.self) { tag in
                    MagiTag(label: tag, color: theme.accentSecondary)
                }
                Text(metadata.uppercased())
                    .font(MagiFont.tiny)
                    .tracking(theme.style.labelTracking - 0.7)
                    .foregroundStyle(theme.textMuted)
            }
            .padding(.horizontal, MagiSpacing.md)
            .padding(.vertical, MagiSpacing.sm)
        }
        .frame(height: 32)
        .contentShape(Rectangle())
        .background(isHovered ? theme.bgSurface : theme.bgSecondary)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(taskAccessibilityLabel)
    }

    private var taskAccessibilityLabel: String {
        var parts = [title]
        if !priority.accessibilityDescription.isEmpty {
            parts.append(priority.accessibilityDescription)
        }
        if !tags.isEmpty {
            parts.append("tags: \(tags.joined(separator: ", "))")
        }
        parts.append(metadata)
        return parts.joined(separator: ", ")
    }
}

// MARK: - Data Readout
public struct DataReadout: View {
    public let label: String
    public let value: String
    public var color: Color?
    @Environment(\.magiTheme) private var theme

    public init(label: String, value: String, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }

    public var body: some View {
        HStack(spacing: MagiSpacing.sm) {
            Text(label.uppercased())
                .font(MagiFont.tiny)
                .tracking(theme.style.labelTracking)
                .foregroundStyle(theme.textMuted)
                .frame(width: 80, alignment: .leading)
            Rectangle()
                .fill(theme.border)
                .frame(width: 1, height: 12)
            Text(value)
                .font(MagiFont.body)
                .foregroundStyle(color ?? theme.textPrimary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}

// MARK: - Alert Banner
public enum AlertLevel {
    case info, warning, critical
    public func color(in theme: MagiTheme) -> Color {
        switch self {
        case .info: return theme.accentSecondary
        case .warning: return theme.accentWarning
        case .critical: return theme.danger
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
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.magiTheme) private var theme

    public init(level: AlertLevel, message: String) {
        self.level = level
        self.message = message
    }

    public var body: some View {
        let levelColor = level.color(in: theme)
        HStack(spacing: MagiSpacing.sm) {
            Rectangle().fill(levelColor).frame(width: 3)
            HStack(spacing: MagiSpacing.sm) {
                Text(level.prefix)
                    .font(MagiFont.tiny).tracking(theme.style.labelTracking).foregroundStyle(levelColor)
                Text(message)
                    .font(MagiFont.body).foregroundStyle(theme.textPrimary).lineLimit(1)
                Spacer()
            }
        }
        .padding(.vertical, MagiSpacing.sm)
        .padding(.trailing, MagiSpacing.md)
        .background(levelColor.opacity(contrast == .increased ? 0.15 : 0.06))
        .overlay {
            Rectangle()
                .stroke(levelColor.opacity(contrast == .increased ? 0.5 : 0.2), lineWidth: theme.style.borderWidth)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(level.prefix): \(message)")
    }
}

// MARK: - Sidebar Item
public struct SidebarItem: View {
    public let label: String
    public let isActive: Bool
    public var count: Int?
    @State private var isHovered = false
    @Environment(\.magiTheme) private var theme

    public init(label: String, isActive: Bool, count: Int? = nil) {
        self.label = label
        self.isActive = isActive
        self.count = count
    }

    public var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(isActive ? theme.accent : .clear)
                .frame(width: theme.style.activeIndicatorWidth)
            itemContent
                .padding(.horizontal, MagiSpacing.md)
                .padding(.vertical, MagiSpacing.sm)
        }
        .contentShape(Rectangle())
        .background(isHovered ? theme.bgSurface : .clear)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(count.map { "\(label), \($0) items" } ?? label)
        .accessibilityAddTraits(isActive ? [.isButton, .isSelected] : .isButton)
    }

    private var itemContent: some View {
        HStack {
            Text(label)
                .font(MagiFont.body)
                .foregroundStyle(
                    isActive ? theme.textPrimary :
                    isHovered ? theme.textPrimary : theme.textMuted
                )
            Spacer()
            if let count {
                Text("\(count)")
                    .font(MagiFont.tiny).foregroundStyle(theme.textMuted)
            }
        }
    }
}

// MARK: - Section Header
public struct SectionHeader: View {
    public let title: String
    @Environment(\.magiTheme) private var theme
    public init(title: String) { self.title = title }
    public var body: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.xs) {
            Text(title.uppercased())
                .font(MagiFont.tiny).tracking(theme.style.labelTracking + 0.5).foregroundStyle(theme.textMuted)
            Rectangle().fill(theme.border).frame(height: 1).accessibilityHidden(true)
        }
        .accessibilityAddTraits(.isHeader)
    }
}
// MARK: - Divider
public struct MagiDivider: View {
    @Environment(\.magiTheme) private var theme
    public init() {}
    public var body: some View {
        Rectangle().fill(theme.border).frame(height: 1).accessibilityHidden(true)
    }
}
