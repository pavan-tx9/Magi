import SwiftUI
import Magi

enum ShowcaseSection: String, CaseIterable {
    case system = "Design System"
    case controls = "Controls"
    case display = "Data Display"
    case visuals = "Visualizations"
}

struct ComponentShowcase: View {
    @State var inputText = ""
    @State var commandText = ""
    @State private var selectedSection = ShowcaseSection.system
    @State var toggleOn = true
    @State var toggleOff = false
    @State var checked = true
    @State var unchecked = false
    @State var showModal = false
    @State var showConfirm = false
    @State var showDestructive = false

    var theme: MagiTheme { .nerv }

    var body: some View {
        HStack(spacing: 0) {
            sidebarPanel
            mainPanel
        }
        .magiWindow()
        .magiModal(isPresented: $showModal, title: "System Status", actions: [
            .cancel(label: "Close", action: { showModal = false }),
            .primary(label: "Acknowledge", action: { showModal = false }),
        ]) {
            VStack(alignment: .leading, spacing: MagiSpacing.sm) {
                DataReadout(label: "Uptime", value: "04:32:17", color: theme.accentSecondary)
                DataReadout(label: "Memory", value: "87% utilized", color: theme.accentWarning)
                DataReadout(label: "Status", value: "Nominal", color: theme.accentSuccess)
            }
        }
        .magiConfirm(
            isPresented: $showConfirm,
            title: "Confirm Operation",
            message: "Deploy build 0.1.0 to production environment? This will replace the current release.",
            confirmLabel: "Deploy",
            onConfirm: {}
        )
        .magiConfirm(
            isPresented: $showDestructive,
            title: "Delete Archive",
            message: "Permanently delete 37 archived operations? This action cannot be undone.",
            confirmLabel: "Delete",
            destructive: true,
            onConfirm: {}
        )
        .magiTheme(theme)
        .onAppear { syncWindowBackground() }
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
        .background(theme.bgPrimary)
        .overlay(alignment: .trailing) {
            Rectangle().fill(theme.border).frame(width: 1)
        }
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            GlowText(text: "MAGI", font: MagiFont.headingLarge)
            Text("NERV")
                .magiLabelWide()
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

            ForEach(ShowcaseSection.allCases, id: \.self) { section in
                SidebarItem(label: section.rawValue, isActive: selectedSection == section)
                    .onTapGesture { selectedSection = section }
            }
        }
    }

    private var sidebarFooter: some View {
        VStack(spacing: 0) {
            MagiDivider()
            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                HStack {
                    Text("SYS")
                        .magiLabelWide()
                    Spacer()
                    StatusBadge(status: .nominal)
                }
                MagiProgress(value: 0.72, color: theme.accentSecondary, height: 3)
                Text("MAGI v0.1.0")
                    .font(MagiFont.tiny)
                    .tracking(1)
                    .foregroundStyle(theme.textMuted)
            }
            .padding(MagiSpacing.md)
        }
    }

    // MARK: - Main Panel

    private var mainPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MagiSpacing.lg) {
                switch selectedSection {
                case .system:
                    colorPaletteSection
                    typographySection
                    spacingSection
                    modifiersSection
                case .controls:
                    buttonSection
                    inputSection
                    toggleSection
                    commandBarSection
                    modalSection
                case .display:
                    alertsSection
                    statusSection
                    tagSection
                    progressSection
                    keyHintSection
                    dataReadoutSection
                    taskListSection
                case .visuals:
                    syncRateSection
                    powerSection
                    gaugesSection
                    oscilloscopeSection
                    barChartSection
                    sparklineSection
                    if theme.style.showDecorations {
                        radarSection
                        hexGridSection
                        dataStreamSection
                        reticleSection
                    }
                    bootSequenceSection
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(MagiSpacing.lg)
            .padding(.bottom, 40)
        }
        .background(theme.bgPrimary)
    }

    private func syncWindowBackground() {
        guard let window = NSApp.windows.first else { return }
        window.backgroundColor = NSColor(theme.bgPrimary)
    }
}
