import SwiftUI
import Magi

extension ComponentShowcase {

    var gaugesSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Gauges")

            HStack(spacing: MagiSpacing.xl) {
                CircularGauge(value: 0.72, label: "Sync", color: theme.accentSecondary)
                CircularGauge(value: 0.45, label: "Load", color: theme.accentSuccess)
                CircularGauge(value: 0.91, label: "Mem", color: theme.accentWarning)
                CircularGauge(value: 0.96, label: "Crit", color: theme.danger)
            }
        }
    }

    var oscilloscopeSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Oscilloscope")

            VStack(spacing: 1) {
                HStack {
                    Text("CH-1  FREQ: 3.0Hz  AMP: 0.8")
                        .font(MagiFont.tiny)
                        .tracking(1)
                        .foregroundStyle(theme.accentSuccess)
                    Spacer()
                    StatusBadge(status: .nominal)
                }

                OscilloscopeView(color: theme.accentSuccess, amplitude: 0.8, frequency: 3)
                    .frame(height: 100)
                    .magiPanel()
            }
            .frame(maxWidth: 500)
        }
    }

    var barChartSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Bar Chart")

            BarChart(data: [
                ("MON", 0.6, theme.accentSecondary),
                ("TUE", 0.85, theme.accentSecondary),
                ("WED", 0.4, theme.accentSecondary),
                ("THU", 0.95, theme.accentWarning),
                ("FRI", 0.7, theme.accentSecondary),
                ("SAT", 0.3, theme.accentSuccess),
                ("SUN", 0.15, theme.accentSuccess),
            ], height: 80)
            .frame(maxWidth: 350)
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }

    var sparklineSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Sparklines")

            HStack(spacing: MagiSpacing.lg) {
                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("THROUGHPUT")
                        .magiLabel()
                    Sparkline(
                        data: [12, 15, 8, 22, 18, 25, 20, 28, 32, 27, 35, 30],
                        color: theme.accentSecondary,
                        height: 36
                    )
                }
                .frame(maxWidth: 200)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("ERROR RATE")
                        .magiLabel()
                    Sparkline(
                        data: [2, 1, 3, 1, 5, 8, 12, 9, 6, 3, 2, 1],
                        color: theme.danger,
                        height: 36
                    )
                }
                .frame(maxWidth: 200)
            }
        }
    }

    var syncRateSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Sync Rate")

            HStack(spacing: MagiSpacing.xl) {
                SyncRateDisplay(rates: [
                    ("UNIT-00", 0.68, theme.accentSecondary),
                    ("UNIT-01", 0.94, theme.accentSuccess),
                    ("UNIT-02", 0.82, theme.accentWarning),
                ], height: 160)
                .frame(width: 220)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    DataReadout(label: "Pilot", value: "Ikari, S.", color: theme.accent)
                    DataReadout(label: "Sync", value: "94.2%", color: theme.accentSuccess)
                    DataReadout(label: "Neural", value: "Nominal", color: theme.accentSuccess)
                    DataReadout(label: "Plug Depth", value: "47.3m", color: theme.accentSecondary)

                    Spacer().frame(height: MagiSpacing.sm)

                    StatusBadge(status: .nominal)
                }
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }

    var powerSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Power Countdown")

            VStack(alignment: .leading, spacing: MagiSpacing.md) {
                PowerCountdown(remaining: 0.75, width: 400)
                PowerCountdown(remaining: 0.15, width: 400)
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }

    var radarSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Radar")

            HStack(spacing: MagiSpacing.xl) {
                RadarView(color: theme.accentSuccess, size: 140)
                    .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    DataReadout(label: "Contacts", value: "5 active", color: theme.accentSuccess)
                    DataReadout(label: "Range", value: "200m radius")
                    DataReadout(label: "Sweep", value: "3.0s / rev", color: theme.accentSecondary)

                    Spacer().frame(height: MagiSpacing.sm)

                    StatusBadge(status: .nominal)
                }
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }

    var hexGridSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Hex Status Grid")

            HStack(spacing: MagiSpacing.lg) {
                HexGrid(statuses: [
                    theme.accentSuccess, theme.accentSuccess, theme.accentSuccess,
                    theme.accentSuccess, theme.accentWarning, theme.accentSuccess,
                    theme.accentSuccess, theme.accentSuccess, theme.danger,
                    theme.accentSuccess, theme.accentSuccess, theme.accentSuccess,
                    theme.accentSuccess, theme.accentSecondary, theme.accentSuccess,
                ], columns: 5)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    hexLegendRow(theme.accentSuccess, "NOMINAL")
                    hexLegendRow(theme.accentWarning, "WARNING")
                    hexLegendRow(theme.danger, "CRITICAL")
                    hexLegendRow(theme.accentSecondary, "INFO")
                }
            }
        }
    }

    func hexLegendRow(_ color: Color, _ label: String) -> some View {
        HStack(spacing: MagiSpacing.sm) {
            HexCell(color: color)
            Text(label)
                .font(MagiFont.tiny)
                .tracking(1)
                .foregroundStyle(theme.textMuted)
        }
    }

    var dataStreamSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Data Stream")

            DataStream(color: theme.accentSuccess)
                .frame(maxWidth: 350, minHeight: 90)
                .magiPanel()
        }
    }

    var bootSequenceSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Boot Sequence")

            BootSequence()
                .padding(MagiSpacing.md)
                .magiPanel()
                .frame(maxWidth: 450)
        }
    }

    var reticleSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Targeting Reticle")

            HStack(spacing: MagiSpacing.xl) {
                ReticleView(color: theme.accent, size: 120)
                    .frame(width: 140, height: 140)

                ReticleView(color: theme.accentSecondary, size: 80)
                    .frame(width: 100, height: 100)
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }
}
