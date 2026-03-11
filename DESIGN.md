# DESIGN.md — Magi Visual Identity

## Direction

Evangelion-inspired terminal aesthetic. Interfaces built with Magi should feel like operating a command interface in a high-tech facility — angular, technical, high-contrast. The NERV command center atmosphere transforms the entire interface.

## Theme: NERV — Command Center

The central operations room. Red accents on black. Chamfered panels like bulkhead displays. Medium glow, standard density. The baseline Magi experience.

## Color Palette

| Token          | Hex       | Usage                                      |
|----------------|-----------|---------------------------------------------|
| `bg-primary`   | `#0A0A0A` | Main background                             |
| `bg-secondary` | `#141414` | Panels, cards, elevated surfaces            |
| `bg-surface`   | `#1A1A1A` | Input fields, interactive surface backgrounds |
| `border`       | `#2A2A2A` | Default borders, dividers                   |
| `border-focus` | `#CC0000` | Focused/active element borders              |
| `text-primary` | `#E0E0E0` | Primary text                                |
| `text-muted`   | `#707070` | Secondary/metadata text                     |
| `accent-red`   | `#CC0000` | Primary accent — active states, selection   |
| `accent-amber` | `#CC8800` | Warnings, due-soon indicators               |
| `accent-green` | `#00AA66` | Completed/nominal status                    |
| `accent-cyan`  | `#00AAAA` | Informational, links, secondary highlights  |
| `danger`       | `#FF3333` | Overdue, destructive actions                |

## Typography

- **Primary font:** SF Mono (system monospace) — all UI text
- **Fallback:** Menlo, Monaco, Courier New
- **Body:** 13px, weight 400, line-height 1.5
- **Labels/metadata:** 11px, weight 500, uppercase, letter-spacing 0.08em
- **Small labels:** 8px minimum for compact data viz labels (gauges, charts)
- **Headings:** 15-18px, weight 600, no uppercase
- **All caps** for status labels, section headers, and metadata only — never for body text or task titles

## Geometry & Layout

- **No rounded corners.** All radii are 0px or at most 2px.
- **Angular cuts** — use clipped corners (chamfered) on key containers where possible
- **Thin borders** (1px) for structural panel/component borders. Sub-pixel (0.5px) allowed for decorative grid lines and visualization detail.
- **Asymmetric layouts** — sidebar and main panel don't need to feel "balanced"
- **Dense spacing** — 4px base unit. Padding uses spacing tokens only: `xs` (4px), `sm` (8px), `md` (12px), `lg` (16px), `xl` (24px). No arbitrary pixel values.
- **Ruled lines** — use horizontal/vertical hairlines to divide sections, not gaps

## Components

### Buttons
- No fills. Thin 1px border, monospace uppercase label, small (11px)
- On hover: border color shifts to `accent-red`
- No rounded corners

### Input Fields
- `bg-surface` background, 1px `border` outline
- On focus: border becomes `border-focus` (red)
- No placeholder animations. Static uppercase placeholder text in `text-muted`

### Task Items
- Single row, dense. No cards with shadows.
- Left edge: thin 2px color bar indicating status (red=overdue, amber=due soon, green=done, none=default)
- Title in `text-primary`, metadata (date, tags) in `text-muted` uppercase 11px
- Completed tasks: strikethrough + `text-muted` color, no other decoration

### Status Indicators
- Small uppercase labels: `NOMINAL`, `PENDING`, `OVERDUE`, `COMPLETE`
- Colored with the corresponding accent color
- Optional subtle pulse/glow animation on `OVERDUE` items only

### Sidebar
- Narrow, dark (`bg-primary`), thin right border
- Section labels uppercase, tiny, `text-muted`
- Active item: left 2px red bar, text becomes `text-primary`
- No icons unless absolutely necessary. Text-only navigation.

## Texture & Effects

- **Scan lines:** Optional — very subtle overlay, 1px repeating horizontal lines at ~10% opacity
- **Noise grain:** Optional — faint background noise texture at ~3-5% opacity
- **Glow:** Subtle shadow glow on accent-colored elements, gated by `glowIntensity`. Used for emphasis on data visualizations, reticles, and heading text. Intensity 0 = no glow.
- **No gradients.** Flat colors only. Use opacity-stepped arcs or layers for sweep/trail effects.
- **No elevation shadows.** Borders and color contrast create hierarchy. The only `.shadow()` allowed is for glow effects gated on `glowIntensity`.
- **Text selection:** Enabled globally via `.textSelection(.enabled)` on the window modifier.

## Language & Tone

The UI should use clinical/technical language where it feels natural:
- "Operations" instead of "Tasks" (optional, user preference)
- Status labels feel like system readouts
- Empty states: terse, not cute. "No active operations." not "Nothing to see here! 🎉"
- Error messages: direct. "Write failed. Check disk permissions." not "Oops, something went wrong."

## What This Is NOT

- Not literal cosplay. The theme channels the *atmosphere* of NERV — it feels like a command center, not "here's the NERV logo."
- Not a dark theme slapped on a normal app. The geometry and typography ARE the identity.
- Not maximalist. Dense ≠ cluttered. Every element earns its space.
