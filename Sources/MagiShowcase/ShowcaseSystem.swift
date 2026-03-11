import SwiftUI
import Magi

extension ComponentShowcase {

    var colorPaletteSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Color Palette")

            Text("12 design tokens. Dark background, light text, 4 accent colors.")
                .magiBodyMuted()

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

    func colorSwatch(_ color: Color, _ label: String) -> some View {
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

    var typographySection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.xs) {
            SectionHeader(title: "Typography")

            Text("All monospace. 6 font tokens from 10px to 18px.")
                .magiBodyMuted()
                .padding(.bottom, MagiSpacing.xs)

            GlowText(text: "Glow Heading — Accent elements", font: MagiFont.headingLarge)

            Text("Heading Large — 18px Semibold")
                .magiHeadingLarge()

            Text("Heading — 15px Semibold")
                .magiHeading()

            Text("Body — 13px Regular monospace")
                .magiBody()

            Text("Body Medium — 13px Medium weight")
                .font(MagiFont.bodyMedium)
                .foregroundStyle(MagiColor.textPrimary)

            Text("LABEL — 11PX MEDIUM UPPERCASE TRACKING")
                .font(MagiFont.label)
                .tracking(1)
                .foregroundStyle(MagiColor.textMuted)

            Text("TINY — 10PX METADATA AND STATUS READOUTS")
                .magiLabel()

            HStack(spacing: MagiSpacing.xs) {
                Text("Blinking cursor")
                    .magiBody()
                BlinkingCursor()
            }
        }
    }

    var spacingSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "Spacing Scale")

            Text("5 spacing tokens. Dense by default — 4px base unit.")
                .magiBodyMuted()
                .padding(.bottom, MagiSpacing.xs)

            spacingRow("XS", MagiSpacing.xs)
            spacingRow("SM", MagiSpacing.sm)
            spacingRow("MD", MagiSpacing.md)
            spacingRow("LG", MagiSpacing.lg)
            spacingRow("XL", MagiSpacing.xl)
        }
    }

    func spacingRow(_ label: String, _ value: CGFloat) -> some View {
        HStack(spacing: MagiSpacing.sm) {
            Text(label)
                .font(MagiFont.tiny)
                .tracking(1.5)
                .foregroundStyle(MagiColor.textMuted)
                .frame(width: 24, alignment: .trailing)

            Rectangle()
                .fill(MagiColor.accentCyan.opacity(0.5))
                .frame(width: value * 6, height: 12)
                .overlay { Rectangle().stroke(MagiColor.accentCyan, lineWidth: 1) }

            Text("\(Int(value))px")
                .font(MagiFont.tiny)
                .foregroundStyle(MagiColor.textMuted)
        }
    }

    var modifiersSection: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.sm) {
            SectionHeader(title: "View Modifiers")

            Text("Apply the Magi aesthetic to any view with one modifier.")
                .magiBodyMuted()
                .padding(.bottom, MagiSpacing.xs)

            HStack(spacing: MagiSpacing.sm) {
                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text(".magiPanel()")
                        .magiLabel()
                    Text("Standard bordered panel")
                        .magiBody()
                }
                .padding(MagiSpacing.md)
                .magiPanel()

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text(".magiPanel(accent:)")
                        .magiLabel()
                    Text("Accent colored border")
                        .magiBody()
                }
                .padding(MagiSpacing.md)
                .magiPanel(accent: MagiColor.accentCyan)
            }

            HStack(spacing: MagiSpacing.sm) {
                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text(".magiChamferPanel()")
                        .magiLabel()
                    Text("Angled corners")
                        .magiBody()
                }
                .padding(MagiSpacing.md)
                .magiChamferPanel()

                VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                    Text(".magiChamferPanel(accent:)")
                        .magiLabel()
                    Text("Accent chamfer")
                        .magiBody()
                }
                .padding(MagiSpacing.md)
                .magiChamferPanel(cut: 8, accent: MagiColor.accentRed)
            }

            VStack(alignment: .leading, spacing: MagiSpacing.xs) {
                Text("TEXT MODIFIERS")
                    .magiLabel()
                    .padding(.bottom, MagiSpacing.xs)

                HStack(spacing: MagiSpacing.lg) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(".magiHeadingLarge()")
                            .magiLabel()
                        Text("Heading Large")
                            .magiHeadingLarge()
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(".magiBody()")
                            .magiLabel()
                        Text("Body text")
                            .magiBody()
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(".magiBodyMuted()")
                            .magiLabel()
                        Text("Muted text")
                            .magiBodyMuted()
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(".magiLabel()")
                            .magiLabel()
                        Text("LABEL TEXT")
                            .magiLabel()
                    }
                }
            }
            .padding(MagiSpacing.md)
            .magiPanel()
        }
    }
}
