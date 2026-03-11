# Magi

A SwiftUI component library for macOS. Angular, monospace, high-contrast. No rounded corners.

## Install

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/pavan/magi", from: "0.1.0"),
]
```

```swift
import Magi
```

Requires macOS 14+.

## Components

### Design Tokens

`MagiColor` — 12 colors from `bgPrimary` (#0A0A0A) to `danger` (#FF3333)

`MagiFont` — 6 monospace font styles (body, bodyMedium, label, heading, headingLarge, tiny)

`MagiSpacing` — 5 spacing values (xs: 4, sm: 8, md: 12, lg: 16, xl: 24)

### Controls

| Component | Description |
|-----------|-------------|
| `MagiButton` | Bordered uppercase label, hover accent |
| `MagiChamferButton` | Angled-corner button variant |
| `MagiIconButton` | SF Symbol in a bordered square |
| `MagiToggle` | I/O toggle with optional label |
| `MagiCheckbox` | Square checkbox with optional label |
| `MagiTextField` | Monospace input with focus border |
| `CommandBar` | Terminal-style input with `>` prompt |

### Data Display

| Component | Description |
|-----------|-------------|
| `StatusBadge` | NOMINAL / PENDING / OVERDUE / COMPLETE |
| `MagiTag` | Small bordered label |
| `MagiProgress` | Flat progress bar |
| `KeyHint` | Keyboard shortcut display |
| `DataReadout` | Label-value pair with divider |
| `AlertBanner` | Info / Warning / Critical with color bar |
| `TaskRow` | Dense row with priority bar, tags, metadata |
| `SidebarItem` | Nav item with active indicator |
| `SectionHeader` | Uppercase label with ruled line |
| `GlowText` | Text with red glow shadow |
| `BlinkingCursor` | Animated terminal cursor |

### Visualizations

| Component | Description |
|-----------|-------------|
| `CircularGauge` | Arc gauge with tick marks |
| `OscilloscopeView` | Animated sine waveform with grid |
| `BarChart` | Vertical bar chart |
| `Sparkline` | Mini line chart with fill |
| `RadarView` | Rotating sweep with blips |
| `ReticleView` | Dual rotating crosshair rings |
| `HexGrid` | Honeycomb status grid |
| `DataStream` | Scrolling hex character matrix |
| `BootSequence` | Timed terminal boot messages |

### Shapes & Effects

| Component | Description |
|-----------|-------------|
| `ChamferShape` | Rectangle with angled corners |
| `ScanLinesOverlay` | CRT scan line effect |
| `MagiDivider` | 1px horizontal rule |

### View Modifiers

| Modifier | Description |
|----------|-------------|
| `.magiWindow()` | Full window treatment: background, font, scan lines |
| `.magiPanel()` | Bordered panel with secondary background |
| `.magiPanel(accent:)` | Panel with custom accent border |
| `.magiChamferPanel()` | Angled-corner panel variant |
| `.magiSurface()` | Surface background without border |

### Text Modifiers

| Modifier | Description |
|----------|-------------|
| `.magiBody()` | 13px monospace, primary color |
| `.magiBodyMuted()` | 13px monospace, muted color |
| `.magiHeading()` | 15px semibold, primary color |
| `.magiHeadingLarge()` | 18px semibold, primary color |
| `.magiLabel()` | 10px uppercase with tracking, muted |
| `.magiLabelWide()` | Same as label with wider tracking |

## Example

```swift
import SwiftUI
import Magi

struct MyView: View {
    @State private var enabled = true

    var body: some View {
        VStack(alignment: .leading, spacing: MagiSpacing.md) {
            GlowText(text: "SYSTEM STATUS", font: MagiFont.headingLarge)
            MagiToggle(isOn: $enabled, label: "Active")
            MagiProgress(value: 0.72, color: MagiColor.accentCyan)
            MagiButton(label: "Execute", action: { })
        }
        .padding(MagiSpacing.lg)
        .magiWindow()
    }
}
```

## Showcase

The package includes a demo app showing all components:

```
swift build
open .build/debug/MagiShowcase
```

Or open `Package.swift` in Xcode and run the **MagiShowcase** target.

## License

MIT
