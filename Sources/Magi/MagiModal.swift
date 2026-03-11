import SwiftUI

// MARK: - Modal Action

public enum MagiModalAction {
    case primary(label: String, action: () -> Void)
    case destructive(label: String, action: () -> Void)
    case cancel(label: String, action: () -> Void)

    var label: String {
        switch self {
        case .primary(let label, _): return label
        case .destructive(let label, _): return label
        case .cancel(let label, _): return label
        }
    }

    var action: () -> Void {
        switch self {
        case .primary(_, let action): return action
        case .destructive(_, let action): return action
        case .cancel(_, let action): return action
        }
    }

    var accent: Color {
        switch self {
        case .primary: return MagiColor.accentCyan
        case .destructive: return MagiColor.danger
        case .cancel: return MagiColor.border
        }
    }
}

// MARK: - Modal

public struct MagiModal<Content: View>: View {
    public let title: String
    public let actions: [MagiModalAction]
    @ViewBuilder public let content: () -> Content

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    public init(
        title: String,
        actions: [MagiModalAction],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.actions = actions
        self.content = content
    }

    public var body: some View {
        ZStack {
            backdrop
            dialogPanel
        }
        .ignoresSafeArea()
        .onAppear {
            guard !reduceMotion else {
                appeared = true
                return
            }
            withAnimation(.easeOut(duration: 0.15)) {
                appeared = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Dialog: \(title)")
    }

    private var backdrop: some View {
        Rectangle()
            .fill(Color.black.opacity(appeared ? 0.6 : 0))
            .allowsHitTesting(true)
            .accessibilityHidden(true)
    }

    private var dialogPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleBar
            MagiDivider()
            contentArea
            MagiDivider()
            actionBar
        }
        .frame(minWidth: 320, maxWidth: 480)
        .background(MagiColor.bgPrimary)
        .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
        .overlay(alignment: .top) { accentLine }
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.97)
    }

    private var titleBar: some View {
        HStack {
            Text(title.uppercased())
                .font(MagiFont.label)
                .tracking(1.5)
                .foregroundStyle(MagiColor.textPrimary)
            Spacer()
            Text("SYS")
                .font(MagiFont.tiny)
                .tracking(1)
                .foregroundStyle(MagiColor.textMuted)
        }
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, MagiSpacing.sm)
    }

    private var contentArea: some View {
        content()
            .font(MagiFont.body)
            .foregroundStyle(MagiColor.textPrimary)
            .padding(MagiSpacing.md)
    }

    private var actionBar: some View {
        HStack(spacing: MagiSpacing.sm) {
            Spacer()
            ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                MagiButton(label: action.label, action: action.action, accent: action.accent)
            }
        }
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, MagiSpacing.sm)
    }

    private var accentLine: some View {
        Rectangle()
            .fill(MagiColor.accentRed)
            .frame(height: 2)
            .accessibilityHidden(true)
    }
}

// MARK: - Confirm Dialog

public struct MagiConfirmDialog: View {
    public let title: String
    public let message: String
    public let confirmLabel: String
    public let onConfirm: () -> Void
    public let onCancel: () -> Void
    public var destructive: Bool

    public init(
        title: String,
        message: String,
        confirmLabel: String = "Confirm",
        destructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmLabel = confirmLabel
        self.destructive = destructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    public var body: some View {
        MagiModal(title: title, actions: dialogActions) {
            Text(message)
                .magiBody()
        }
    }

    private var dialogActions: [MagiModalAction] {
        let confirm: MagiModalAction = destructive
            ? .destructive(label: confirmLabel, action: onConfirm)
            : .primary(label: confirmLabel, action: onConfirm)
        return [
            .cancel(label: "Cancel", action: onCancel),
            confirm,
        ]
    }
}

// MARK: - View Modifier

public extension View {
    func magiModal<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        actions: [MagiModalAction],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                MagiModal(title: title, actions: actions, content: content)
            }
        }
    }

    func magiConfirm(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmLabel: String = "Confirm",
        destructive: Bool = false,
        onConfirm: @escaping () -> Void
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                MagiConfirmDialog(
                    title: title,
                    message: message,
                    confirmLabel: confirmLabel,
                    destructive: destructive,
                    onConfirm: {
                        isPresented.wrappedValue = false
                        onConfirm()
                    },
                    onCancel: { isPresented.wrappedValue = false }
                )
            }
        }
    }
}
