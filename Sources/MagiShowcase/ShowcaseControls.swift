import SwiftUI
import Magi

// MARK: - Controls Section

extension ComponentShowcase {

    var buttonSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Buttons")

            HStack(spacing: MagiSpacing.sm) {
                MagiButton(label: "Execute", action: {})
                MagiButton(label: "Abort", action: {}, accent: MagiColor.danger)
                MagiChamferButton(label: "Deploy", action: {})
            }

            HStack(spacing: MagiSpacing.sm) {
                MagiIconButton(symbol: "plus", action: {})
                MagiIconButton(symbol: "trash", action: {})
                MagiIconButton(symbol: "arrow.clockwise", action: {})
                MagiIconButton(symbol: "gearshape", action: {})
            }
        }
    }

    var inputSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Input Fields")

            HStack(spacing: MagiSpacing.sm) {
                MagiTextField(placeholder: "Operation name", text: $inputText)
                MagiButton(label: "Submit", action: {})
            }
            .frame(maxWidth: 450)
        }
    }

    var toggleSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Toggles & Checkboxes")

            HStack(spacing: MagiSpacing.xl) {
                MagiToggle(isOn: $toggleOn, label: "Enabled")
                MagiToggle(isOn: $toggleOff, label: "Disabled")
            }

            HStack(spacing: MagiSpacing.xl) {
                MagiCheckbox(isChecked: $checked, label: "Checked")
                MagiCheckbox(isChecked: $unchecked, label: "Unchecked")
            }
        }
    }

    var commandBarSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Command Bar")

            CommandBar(text: $commandText)
                .frame(maxWidth: 500)
        }
    }

    var modalSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Modals & Dialogs")

            Text("Overlay dialogs with backdrop, title bar, and action buttons.")
                .magiBodyMuted()

            HStack(spacing: MagiSpacing.sm) {
                MagiButton(label: "Custom Modal", action: { showModal = true })
                MagiButton(label: "Confirm", action: { showConfirm = true })
                MagiButton(label: "Destructive", action: { showDestructive = true },
                           accent: MagiColor.danger)
            }

            Text("Also available as view modifiers: .magiModal() and .magiConfirm()")
                .magiLabel()
        }
    }
}

// MARK: - Data Display Section

extension ComponentShowcase {

    var alertsSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            SectionHeader(title: "Alert Banners")
                .padding(.bottom, MagiSpacing.xs)

            AlertBanner(level: .info, message: "System initialized. All modules loaded.")
            AlertBanner(level: .warning, message: "Memory usage at 87%. Consider archiving.")
            AlertBanner(level: .critical, message: "3 operations overdue. Immediate action required.")
        }
    }

    var statusSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Status Indicators")

            HStack(spacing: MagiSpacing.lg) {
                StatusBadge(status: .nominal)
                StatusBadge(status: .pending)
                StatusBadge(status: .overdue)
                StatusBadge(status: .complete)
            }
        }
    }

    var tagSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Tags")

            HStack(spacing: MagiSpacing.sm) {
                MagiTag(label: "Backend", color: MagiColor.accentCyan)
                MagiTag(label: "Urgent", color: MagiColor.danger)
                MagiTag(label: "Design", color: MagiColor.accentAmber)
                MagiTag(label: "v0.1", color: MagiColor.accentGreen)
                MagiTag(label: "Blocked", color: MagiColor.textMuted)
            }
        }
    }

    var progressSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Progress Bars")

            progressRow(label: "SYNC", percent: "72%", value: 0.72, color: MagiColor.accentCyan)
            progressRow(label: "MEMORY", percent: "87%", value: 0.87, color: MagiColor.accentAmber)
            progressRow(label: "CRITICAL", percent: "96%", value: 0.96, color: MagiColor.danger)
        }
    }

    func progressRow(label: String, percent: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: MagiSpacing.xs) {
            HStack {
                Text(label)
                    .magiLabel()
                Spacer()
                Text(percent)
                    .font(MagiFont.tiny)
                    .foregroundStyle(color)
            }
            MagiProgress(value: value, color: color)
        }
        .frame(maxWidth: 350)
    }

    var keyHintSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Key Commands")

            HStack(spacing: MagiSpacing.lg) {
                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "N"])
                    Text("New operation")
                        .magiBodyMuted()
                }

                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "⇧", "A"])
                    Text("Archive")
                        .magiBodyMuted()
                }

                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "K"])
                    Text("Command bar")
                        .magiBodyMuted()
                }
            }
        }
    }

    var dataReadoutSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Data Readouts")

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                DataReadout(label: "Active", value: "4 operations", color: MagiColor.textPrimary)
                DataReadout(label: "Overdue", value: "1 operation", color: MagiColor.danger)
                DataReadout(label: "Completed", value: "37 this week", color: MagiColor.accentGreen)
                DataReadout(label: "Uptime", value: "04:32:17", color: MagiColor.accentCyan)
            }
            .padding(MagiSpacing.md)
            .magiPanel()
            .frame(maxWidth: 320)
        }
    }

    var taskListSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            SectionHeader(title: "Task Items")
                .padding(.bottom, MagiSpacing.xs)

            TaskRow(title: "Initialize project repository", metadata: "2026-03-11", priority: .done)
            TaskRow(title: "Design component system", metadata: "2026-03-11", priority: .normal, tags: ["Design"])
            TaskRow(title: "Implement persistence layer", metadata: "2026-03-12", priority: .dueSoon, tags: ["Backend"])
            TaskRow(title: "Write integration tests", metadata: "OVERDUE", priority: .overdue)
            TaskRow(title: "Deploy to production", metadata: "2026-03-15", priority: .none, tags: ["v0.1"])
        }
    }
}
