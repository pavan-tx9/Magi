import SwiftUI
import Magi

struct ComponentShowcase: View {
    @State private var inputText = ""
    @State private var commandText = ""
    @State private var selectedSection = "components"
    @State private var toggleOn = true
    @State private var toggleOff = false
    @State private var checked = true
    @State private var unchecked = false

    var body: some View {
        HStack(spacing: 0) {
            sidebarPanel
            mainPanel
        }
        .background(MagiColor.bgPrimary)
        .overlay { ScanLinesOverlay() }
    }

    // MARK: - Sidebar

    private var sidebarPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerBlock
            MagiDivider()
            sidebarNav
            Spacer()
            sidebarFooter
        }
        .frame(width: 180)
        .background(MagiColor.bgPrimary)
        .overlay(alignment: .trailing) {
            Rectangle().fill(MagiColor.border).frame(width: 1)
        }
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            GlowText(text: "MAGI", font: MagiFont.headingLarge)
            Text("COMPONENT LIBRARY")
                .font(MagiFont.tiny)
                .tracking(2)
                .foregroundStyle(MagiColor.textMuted)
        }
        .padding(.horizontal, MagiSpacing.md)
        .padding(.vertical, MagiSpacing.md)
    }

    private var sidebarNav: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Showcase")
                .padding(.horizontal, MagiSpacing.md)
                .padding(.top, MagiSpacing.md)
                .padding(.bottom, MagiSpacing.xs)

            SidebarItem(label: "Components", isActive: selectedSection == "components", count: 22)
                .onTapGesture { selectedSection = "components" }
            SidebarItem(label: "Typography", isActive: selectedSection == "typography")
                .onTapGesture { selectedSection = "typography" }
            SidebarItem(label: "Visuals", isActive: selectedSection == "visuals")
                .onTapGesture { selectedSection = "visuals" }
            SidebarItem(label: "Animations", isActive: selectedSection == "animations")
                .onTapGesture { selectedSection = "animations" }
        }
    }

    private var sidebarFooter: some View {
        VStack(spacing: 0) {
            MagiDivider()
            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                HStack {
                    Text("SYS")
                        .font(MagiFont.tiny)
                        .tracking(2)
                        .foregroundStyle(MagiColor.textMuted)
                    Spacer()
                    StatusBadge(status: .nominal)
                }
                MagiProgress(value: 0.72, color: MagiColor.accentCyan, height: 3)
                Text("MAGI v0.1.0")
                    .font(MagiFont.tiny)
                    .tracking(1)
                    .foregroundStyle(MagiColor.textMuted)
            }
            .padding(MagiSpacing.md)
        }
    }

    // MARK: - Main Panel

    private var mainPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MagiSpacing.lg) {
                alertsSection
                typographySection
                colorPaletteSection
                buttonSection
                inputSection
                toggleSection
                progressSection
                statusSection
                tagSection
                keyHintSection
                dataReadoutSection
                taskListSection
                chamferSection
                commandBarSection
                gaugesSection
                oscilloscopeSection
                radarSection
                barChartSection
                sparklineSection
                hexGridSection
                dataStreamSection
                bootSequenceSection
                reticleSection
            }
            .padding(MagiSpacing.lg)
            .padding(.bottom, 40)
        }
        .background(MagiColor.bgPrimary)
    }
}

// MARK: - Showcase Sections

extension ComponentShowcase {

    private var alertsSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            SectionHeader(title: "Alert Banners")
                .padding(.bottom, MagiSpacing.xs)

            AlertBanner(level: .info, message: "System initialized. All modules loaded.")
            AlertBanner(level: .warning, message: "Memory usage at 87%. Consider archiving.")
            AlertBanner(level: .critical, message: "3 operations overdue. Immediate action required.")
        }
    }

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.xs) {
            SectionHeader(title: "Typography")

            GlowText(text: "Glow Heading — Accent elements", font: MagiFont.headingLarge)

            Text("Heading Large — 18px Semibold")
                .font(MagiFont.headingLarge)
                .foregroundStyle(MagiColor.textPrimary)

            Text("Heading — 15px Semibold")
                .font(MagiFont.heading)
                .foregroundStyle(MagiColor.textPrimary)

            Text("Body — 13px Regular monospace for all interface text")
                .font(MagiFont.body)
                .foregroundStyle(MagiColor.textPrimary)

            Text("Body Medium — 13px Medium weight for emphasis")
                .font(MagiFont.bodyMedium)
                .foregroundStyle(MagiColor.textPrimary)

            Text("LABEL — 11PX MEDIUM UPPERCASE TRACKING")
                .font(MagiFont.label)
                .tracking(1)
                .foregroundStyle(MagiColor.textMuted)

            Text("TINY — 10PX METADATA AND STATUS READOUTS")
                .font(MagiFont.tiny)
                .tracking(1.5)
                .foregroundStyle(MagiColor.textMuted)

            HStack(spacing: MagiSpacing.xs) {
                Text("Blinking cursor")
                    .font(MagiFont.body)
                    .foregroundStyle(MagiColor.textPrimary)
                BlinkingCursor()
            }
        }
    }

    private var colorPaletteSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Color Palette")

            HStack(spacing: 6) {
                colorSwatch(MagiColor.bgPrimary, "BG-PRI")
                colorSwatch(MagiColor.bgSecondary, "BG-SEC")
                colorSwatch(MagiColor.bgSurface, "SURFACE")
                colorSwatch(MagiColor.border, "BORDER")
                colorSwatch(MagiColor.textPrimary, "TEXT")
                colorSwatch(MagiColor.textMuted, "MUTED")
            }

            HStack(spacing: 6) {
                colorSwatch(MagiColor.accentRed, "RED")
                colorSwatch(MagiColor.accentAmber, "AMBER")
                colorSwatch(MagiColor.accentGreen, "GREEN")
                colorSwatch(MagiColor.accentCyan, "CYAN")
                colorSwatch(MagiColor.danger, "DANGER")
            }
        }
    }

    private func colorSwatch(_ color: Color, _ label: String) -> some View {
        VStack(spacing: 3) {
            Rectangle()
                .fill(color)
                .frame(width: 40, height: 24)
                .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }

            Text(label)
                .font(.system(size: 8, weight: .medium, design: .monospaced))
                .tracking(0.5)
                .foregroundStyle(MagiColor.textMuted)
        }
    }

    private var buttonSection: some View {
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

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Input Fields")

            HStack(spacing: MagiSpacing.sm) {
                MagiTextField(placeholder: "Operation name", text: $inputText)
                MagiButton(label: "Submit", action: {})
            }
            .frame(maxWidth: 450)
        }
    }

    private var toggleSection: some View {
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

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Progress Bars")

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                HStack {
                    Text("SYNC")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                    Spacer()
                    Text("72%")
                        .font(MagiFont.tiny)
                        .foregroundStyle(MagiColor.accentCyan)
                }
                MagiProgress(value: 0.72, color: MagiColor.accentCyan)
            }
            .frame(maxWidth: 350)

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                HStack {
                    Text("MEMORY")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                    Spacer()
                    Text("87%")
                        .font(MagiFont.tiny)
                        .foregroundStyle(MagiColor.accentAmber)
                }
                MagiProgress(value: 0.87, color: MagiColor.accentAmber)
            }
            .frame(maxWidth: 350)

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                HStack {
                    Text("CRITICAL")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                    Spacer()
                    Text("96%")
                        .font(MagiFont.tiny)
                        .foregroundStyle(MagiColor.danger)
                }
                MagiProgress(value: 0.96, color: MagiColor.danger)
            }
            .frame(maxWidth: 350)
        }
    }

    private var statusSection: some View {
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

    private var tagSection: some View {
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

    private var keyHintSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Key Commands")

            HStack(spacing: MagiSpacing.lg) {
                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "N"])
                    Text("New operation")
                        .font(MagiFont.body)
                        .foregroundStyle(MagiColor.textMuted)
                }

                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "⇧", "A"])
                    Text("Archive")
                        .font(MagiFont.body)
                        .foregroundStyle(MagiColor.textMuted)
                }

                HStack(spacing: MagiSpacing.sm) {
                    KeyHint(keys: ["⌘", "K"])
                    Text("Command bar")
                        .font(MagiFont.body)
                        .foregroundStyle(MagiColor.textMuted)
                }
            }
        }
    }

    private var dataReadoutSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Data Readouts")

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                DataReadout(label: "Active", value: "4 operations", color: MagiColor.textPrimary)
                DataReadout(label: "Overdue", value: "1 operation", color: MagiColor.danger)
                DataReadout(label: "Completed", value: "37 this week", color: MagiColor.accentGreen)
                DataReadout(label: "Uptime", value: "04:32:17", color: MagiColor.accentCyan)
            }
            .padding(MagiSpacing.md)
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
            .frame(maxWidth: 320)
        }
    }

    private var taskListSection: some View {
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

    private var chamferSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Chamfer Containers")

            HStack(spacing: MagiSpacing.sm) {
                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("Standard panel")
                        .font(MagiFont.body)
                        .foregroundStyle(MagiColor.textPrimary)
                    Text("CUT: 10PX")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                }
                .padding(MagiSpacing.md)
                .background { ChamferShape(cut: 10).fill(MagiColor.bgSecondary) }
                .overlay { ChamferShape(cut: 10).stroke(MagiColor.border, lineWidth: 1) }

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("Accent panel")
                        .font(MagiFont.body)
                        .foregroundStyle(MagiColor.textPrimary)
                    Text("CUT: 8PX")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.accentRed)
                }
                .padding(MagiSpacing.md)
                .background { ChamferShape(cut: 8).fill(MagiColor.bgSecondary) }
                .overlay { ChamferShape(cut: 8).stroke(MagiColor.accentRed.opacity(0.3), lineWidth: 1) }
            }
        }
    }

    private var commandBarSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Command Bar")

            CommandBar(text: $commandText)
                .frame(maxWidth: 500)
        }
    }

    // MARK: - Visual Components

    private var gaugesSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Gauges")

            HStack(spacing: MagiSpacing.xl) {
                CircularGauge(value: 0.72, label: "Sync", color: MagiColor.accentCyan)
                CircularGauge(value: 0.45, label: "Load", color: MagiColor.accentGreen)
                CircularGauge(value: 0.91, label: "Mem", color: MagiColor.accentAmber)
                CircularGauge(value: 0.96, label: "Crit", color: MagiColor.danger)
            }
        }
    }

    private var oscilloscopeSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Oscilloscope")

            VStack(spacing: 1) {
                HStack {
                    Text("CH-1  FREQ: 3.0Hz  AMP: 0.8")
                        .font(MagiFont.tiny)
                        .tracking(1)
                        .foregroundStyle(MagiColor.accentGreen)
                    Spacer()
                    StatusBadge(status: .nominal)
                }

                OscilloscopeView(color: MagiColor.accentGreen, amplitude: 0.8, frequency: 3)
                    .frame(height: 100)
                    .background(MagiColor.bgSecondary)
                    .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
            }
            .frame(maxWidth: 500)
        }
    }

    private var radarSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Radar")

            HStack(spacing: MagiSpacing.xl) {
                RadarView(color: MagiColor.accentGreen, size: 140)
                    .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    DataReadout(label: "Contacts", value: "5 active", color: MagiColor.accentGreen)
                    DataReadout(label: "Range", value: "200m radius", color: MagiColor.textPrimary)
                    DataReadout(label: "Sweep", value: "3.0s / rev", color: MagiColor.accentCyan)

                    Spacer().frame(height: MagiSpacing.sm)

                    StatusBadge(status: .nominal)
                }
            }
            .padding(MagiSpacing.md)
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
        }
    }

    private var barChartSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Bar Chart")

            BarChart(data: [
                ("MON", 0.6, MagiColor.accentCyan),
                ("TUE", 0.85, MagiColor.accentCyan),
                ("WED", 0.4, MagiColor.accentCyan),
                ("THU", 0.95, MagiColor.accentAmber),
                ("FRI", 0.7, MagiColor.accentCyan),
                ("SAT", 0.3, MagiColor.accentGreen),
                ("SUN", 0.15, MagiColor.accentGreen),
            ], height: 80)
            .frame(maxWidth: 350)
            .padding(MagiSpacing.md)
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
        }
    }

    private var sparklineSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Sparklines")

            HStack(spacing: MagiSpacing.lg) {
                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("THROUGHPUT")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                    Sparkline(
                        data: [12, 15, 8, 22, 18, 25, 20, 28, 32, 27, 35, 30],
                        color: MagiColor.accentCyan,
                        height: 36
                    )
                }
                .frame(maxWidth: 200)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("ERROR RATE")
                        .font(MagiFont.tiny)
                        .tracking(1.5)
                        .foregroundStyle(MagiColor.textMuted)
                    Sparkline(
                        data: [2, 1, 3, 1, 5, 8, 12, 9, 6, 3, 2, 1],
                        color: MagiColor.danger,
                        height: 36
                    )
                }
                .frame(maxWidth: 200)
            }
        }
    }

    private var hexGridSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Hex Status Grid")

            HStack(spacing: MagiSpacing.lg) {
                HexGrid(statuses: [
                    MagiColor.accentGreen, MagiColor.accentGreen, MagiColor.accentGreen,
                    MagiColor.accentGreen, MagiColor.accentAmber, MagiColor.accentGreen,
                    MagiColor.accentGreen, MagiColor.accentGreen, MagiColor.danger,
                    MagiColor.accentGreen, MagiColor.accentGreen, MagiColor.accentGreen,
                    MagiColor.accentGreen, MagiColor.accentCyan, MagiColor.accentGreen,
                ], columns: 5)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    HStack(spacing: MagiSpacing.sm) {
                        HexCell(color: MagiColor.accentGreen)
                        Text("NOMINAL")
                            .font(MagiFont.tiny)
                            .tracking(1)
                            .foregroundStyle(MagiColor.textMuted)
                    }
                    HStack(spacing: MagiSpacing.sm) {
                        HexCell(color: MagiColor.accentAmber)
                        Text("WARNING")
                            .font(MagiFont.tiny)
                            .tracking(1)
                            .foregroundStyle(MagiColor.textMuted)
                    }
                    HStack(spacing: MagiSpacing.sm) {
                        HexCell(color: MagiColor.danger)
                        Text("CRITICAL")
                            .font(MagiFont.tiny)
                            .tracking(1)
                            .foregroundStyle(MagiColor.textMuted)
                    }
                    HStack(spacing: MagiSpacing.sm) {
                        HexCell(color: MagiColor.accentCyan)
                        Text("INFO")
                            .font(MagiFont.tiny)
                            .tracking(1)
                            .foregroundStyle(MagiColor.textMuted)
                    }
                }
            }
        }
    }

    private var dataStreamSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Data Stream")

            DataStream(color: MagiColor.accentGreen)
                .frame(maxWidth: 350, minHeight: 90)
                .background(MagiColor.bgSecondary)
                .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
        }
    }

    private var bootSequenceSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Boot Sequence")

            BootSequence()
                .padding(MagiSpacing.md)
                .background(MagiColor.bgSecondary)
                .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
                .frame(maxWidth: 450)
        }
    }

    private var reticleSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Targeting Reticle")

            HStack(spacing: MagiSpacing.xl) {
                ReticleView(color: MagiColor.accentRed, size: 120)
                    .frame(width: 140, height: 140)

                ReticleView(color: MagiColor.accentCyan, size: 80)
                    .frame(width: 100, height: 100)
            }
            .padding(MagiSpacing.md)
            .background(MagiColor.bgSecondary)
            .overlay { Rectangle().stroke(MagiColor.border, lineWidth: 1) }
        }
    }
}
