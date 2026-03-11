import SwiftUI
import Magi

extension ComponentShowcase {

    var gaugesSection: some View {
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

    var oscilloscopeSection: some View {
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
                    .magiPanel()
            }
            .frame(maxWidth: 500)
        }
    }

    var barChartSection: some View {
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
                        color: MagiColor.accentCyan,
                        height: 36
                    )
                }
                .frame(maxWidth: 200)

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text("ERROR RATE")
                        .magiLabel()
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

    var radarSection: some View {
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
            .magiPanel()
        }
    }

    var hexGridSection: some View {
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
                    hexLegendRow(MagiColor.accentGreen, "NOMINAL")
                    hexLegendRow(MagiColor.accentAmber, "WARNING")
                    hexLegendRow(MagiColor.danger, "CRITICAL")
                    hexLegendRow(MagiColor.accentCyan, "INFO")
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
                .foregroundStyle(MagiColor.textMuted)
        }
    }

    var dataStreamSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Data Stream")

            DataStream(color: MagiColor.accentGreen)
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
                ReticleView(color: MagiColor.accentRed, size: 120)
                    .frame(width: 140, height: 140)

                ReticleView(color: MagiColor.accentCyan, size: 80)
                    .frame(width: 100, height: 100)
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }
}
