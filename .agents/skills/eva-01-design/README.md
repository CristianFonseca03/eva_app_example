# EVA-01 Design System

A multiplatform design system (iOS, Android, responsive web) inspired by the operational UI of *Neon Genesis Evangelion* — NERV terminals, MAGI dashboards, AT field readouts, hazard placards, and emergency broadcast displays.

The system reads as **urgent, technical, authoritative, and tense** while remaining usable for ordinary product work. The trick (called out in the source brief): Evangelion UI is *natively* an emergency interface. To avoid burning users out, we reserve **red** for genuine destructive/error states and use **amber/orange** as the everyday workhorse. Yellow signals confirmation/active. Hazard stripes are reserved for the rare irreversible action.

This system is **dark-only** by design. There is no light mode.

---

## Sources

This design system was built from a detailed product brief (no codebase, no Figma, no slide deck were attached). All visual decisions trace back to:

- The provided written specification (tokens, components, layouts, animations, accessibility rules)
- Reference imagery in the broader cultural memory of NGE on-screen UI (NERV terminals, alert broadcasts, sync ratio HUDs)

If a source codebase or Figma file becomes available later, re-import via the **Import** menu and we'll align components 1:1.

---

## What's in this repo

| Path | What it is |
| --- | --- |
| `colors_and_type.css` | Every design token as a CSS custom property (colors, type, spacing, shadows, clips). Import this in any artifact. |
| `fonts/` | Webfont declarations. We use Google Fonts substitutes — see *Typography substitution* below. |
| `assets/` | Logos, icons (SVG), hazard pattern, scan-line texture. |
| `preview/` | Per-token cards rendered into the Design System tab. Not for end-user consumption. |
| `ui_kits/web/` | Web (desktop) UI kit: dashboard, detail view, components. |
| `ui_kits/mobile/` | Mobile UI kit: home, form, hazard confirmation modal. |
| `SKILL.md` | Cross-compatible skill manifest. Mirrors this README for Claude Code use. |

---

## Content fundamentals

The voice of the system is the voice of an **operations console**. It's clipped, technical, and slightly cold. Think mission control — not a lifestyle app.

**Casing.** ALL CAPS for labels, buttons, status, micro-tags, section headers, and any data legend. Sentence case is reserved for long-form prose (modal body copy, paragraphs of explanation). Title Case is never used.

**Pronouns.** Second person ("YOU") for direct user addresses, but most copy is impersonal — system-to-operator. The system speaks *about* the world, not *with* the user.

**Tense.** Present-tense, declarative. "TARGET LOCKED." "PROPULSION NOMINAL." "SYNC RATIO 41.3%."

**Number formatting.** Numerics are decoration *and* data. Pad with leading zeros (`007`, `024`). Use technical units (`BR`, `m/s`, `Hz`). Coordinates and times are monospaced and usually displayed prominently.

**Examples — good copy:**
- `EARLY WARNING SYSTEM` (status banner)
- `PERINGATAN DINI` (warning sub-label, kept in original Indonesian/Japanese-style operational tag for flavor)
- `IL-AREA / TSUNAMI / 27.2 BR`
- `CONFIRM IRREVERSIBLE ACTION — TYPE "PURGE" TO PROCEED`
- `[SISTEMA / PROPULSIÓN]` (component micro-label)
- `T-MINUS 00:01:47`

**Examples — bad copy (do NOT do this):**
- "Hey there 👋" — too friendly
- "Ready to launch?" — hedging, not declarative
- "Awesome — it worked!" — celebratory, off-tone
- "Click here to learn more" — generic web tropes

**Emoji policy.** **No emoji.** Substitute geometric icons or unicode glyphs (`▲`, `▼`, `■`, `●`, `◆`, `✕`) when an inline mark is needed. Triangle warning ⚠ is acceptable in alert panels because the real glyph reads as the brand mark.

**Vibe.** Tense, terse, factual. Treat every screen as a console you don't want to misread.

---

## Visual foundations

### Color
- **Background is always black or near-black** (`#0A0A0A`, `#111`, `#1A0800` for tinted-red surface). We never use pure white; values are warm white (`#FFFFFF` only for critical numeric values), most "white" copy is amber.
- **Orange is the workhorse.** Every default border, label, and active text is orange (`--color-warning: #FF6B00`).
- **Red is rationed.** Only for: errors, destructive actions, critical alerts, hazard confirmations.
- **Amber/yellow** signals confirmation and active state — the "sync acquired" feel.
- **Brown undertones** (`#3D1500`, `#8B4513`) ground the palette; they appear in disabled states, deep borders, and structural lines.

### Type
- Three families. **Mono** (Share Tech Mono) for data, codes, and micro-labels. **Display** (Bebas Neue) for screen titles and HUD callouts. **UI** (Rajdhani) for buttons, menu items, body interface text.
- **Letter spacing is wide** — 0.08em to 0.15em on titles. Always.
- **Bold (700)** for values that matter; **regular (400)** for descriptive labels.

### Spacing & geometry
- **4px base unit.** Tokens go 4 → 8 → 12 → 16 → 20 → 24 → 32 → 40 → 48.
- **Border radius is essentially zero** (max 2px). Softness is forbidden — it reads as "consumer app" and breaks the spell.
- **Diagonal clip-paths** replace rounded corners. A panel typically has its top-right or bottom-left corner cut at 45° (6/10/16px depending on element scale). This is the single most important visual signature of the system.
- **Borders** are 1px solid in the deep brown-orange (`--color-border`). 2px for active/focus emphasis.

### Backgrounds
- Black, full-bleed, no images by default.
- **Subtle texture** (very faint scan-lines or noise) is allowed on full-screen surfaces — never on small components.
- **Hazard stripes** (45° yellow-on-black-yellow repeating gradient) reserved for irreversible-action affordances.
- Gradients are otherwise rare; if used, they are radial, dark-to-darker, and never colorful.

### Animation
- **Fast, mechanical, no bounce.** 150ms is the default UI transition; 300ms for panel entrances.
- **Easing**: `ease-in-out` or linear. Never `cubic-bezier` curves with overshoot.
- **Pulse glow** (1.5s ease-in-out infinite) on alert states.
- **Glitch** (2px RGB channel offset) on alert activations. Use sparingly.
- **Type-in** (character-by-character) for system messages — gives the terminal feel.
- **Scan line** sweep on loading screens.
- **Button press**: micro-vibration (2px L/R, 80ms) on destructive actions only.
- **Reduced motion**: honor `prefers-reduced-motion: reduce` — disable pulse, glitch, scan, type-in.

### Hover / press states
- **Hover**: intensify glow + thicken border (1px → 2px). No background lighten — keep things dark.
- **Press**: dim glow ~20% + 1px inward shift. No scale transforms.
- **Disabled**: opacity 0.5, surface-3 fill, `not-allowed` cursor, no glow, no hover.

### Borders & shadows
- **Borders** are the structural backbone. They divide every panel.
- **Drop shadows** are barely there — ambient `0 4px 20px rgba(0,0,0,0.8)` for elevated panels.
- **Glow shadows** carry the meaning (`--shadow-glow-danger`, `-warning`, `-active`). They fire on focus, hover, and emergency state.
- **No inner shadows** as a default decoration — only when an `OUTLINE DANGER` button is replicating a "double border" effect.

### Layout rules
- **Fixed header** at top with system status + active module breadcrumb.
- **Left sidebar** (240px desktop) holds nav.
- **Optional right rail** (280px) for live telemetry.
- **Mobile bottom tab bar** is the standard nav surface.
- **FAB** is **rectangular** with a clip-cut corner — never circular.

### Transparency & blur
- **Modals** use `rgba(0,0,0,0.85)` overlay. Light noise texture on top.
- **Tooltips and floating menus** use `rgba(0,0,0,0.92)` with a 1px orange border.
- Backdrop blur is *not* used by default — softness is off-brand. Only allowed on photo overlays (rare).

### Corner radius
- **Maximum 2px** for any component. Buttons, inputs, cards, modals — all sharp or clipped.

### Cards
- 1px solid border, no shadow, no rounding.
- Top-right corner clipped at 8–10px diagonal.
- A 9px gray micro-label tagged on the upper-left ("[ SYSTEM / PROPULSION ]").
- Internal divider lines are 1px **dashed** in 30%-alpha orange — they read as schematic lines.

---

## Iconography

We use a curated **angular SVG** icon set, custom-drawn for this system, stored in `assets/icons/`. All icons are:

- **1.5px stroke**, no fill (or solid fill, never gradients)
- **Strict 90°/45° geometry** — no curved corners
- **Color: inherit from `currentColor`** — they pick up text color automatically
- **Sizes**: 16, 20, 24, 32px

Provided icons:

| File | Meaning |
| --- | --- |
| `assets/icons/shield.svg` | Security / clearance |
| `assets/icons/triangle-alert.svg` | Warning / hazard |
| `assets/icons/cross.svg` | Error / destructive close |
| `assets/icons/signal.svg` | Connectivity / sync |
| `assets/icons/terminal.svg` | Data / console |
| `assets/icons/clock.svg` | Time / countdown |
| `assets/icons/target.svg` | Target / objective |
| `assets/icons/grid.svg` | Dashboard / overview |
| `assets/icons/lock.svg` | Locked / restricted |
| `assets/icons/chevron-down.svg` | Expand / select |
| `assets/icons/menu.svg` | More options |
| `assets/icons/plus.svg` | Add / create |

**Substitution policy.** This icon set is custom — *not* sourced from a public library. If you need an icon not in the set, prefer **[Lucide](https://lucide.dev)** (similar 1.5–2px stroke geometric style) and document the substitution in your design.

**Emoji policy.** No. See *Content fundamentals*.

**Unicode chars used as glyphs.** ▲ ▼ ◆ ■ ● ✕ ⚠ — these are acceptable inline (e.g. inside dropdowns, sort indicators, alert tags). They render reliably across every platform.

---

## Typography substitution flag ⚠

The brief specifies `Share Tech Mono`, `Bebas Neue`, and `Rajdhani`. **All three are available on Google Fonts** at the exact names — we load them from there. If you need offline `.ttf` / `.woff2` files for production builds, please attach them and we'll bundle into `fonts/` and rewrite `@font-face` to point locally.

Fallback stacks are configured so the system stays readable if Google Fonts is unreachable.

---

## Index

- `README.md` — you are here
- `SKILL.md` — Claude Code-compatible skill manifest
- `colors_and_type.css` — design tokens
- `assets/` — logos and icons
- `assets/icons/` — angular SVG icon set (12 glyphs)
- `assets/logo.svg` — NERV-style monogram
- `assets/hazard-pattern.svg` — diagonal stripe texture
- `preview/*.html` — design-tab cards (one concept per file)
- `ui_kits/web/index.html` — desktop dashboard prototype
- `ui_kits/web/*.jsx` — desktop components
- `ui_kits/mobile/index.html` — mobile prototype (home, form, hazard modal)
- `ui_kits/mobile/*.jsx` — mobile components

---

## When to use what — quick guide

| Situation | Use |
| --- | --- |
| Default button (save, submit, navigate) | **SECONDARY** (orange outline) |
| High-emphasis confirmation that's not destructive | **PRIMARY** (red fill) — sparingly |
| Destructive action (delete, reset, reject) | **OUTLINE DANGER** |
| Catastrophic, irreversible action (purge, self-destruct, fire) | **HAZARD** + confirmation modal w/ typed code |
| Default body text | UI font, amber, regular |
| Numeric data, coordinates, codes | Mono font, white or amber, bold |
| Section headers | Display font, ALL CAPS, wide tracking |
| Status: working / fine | Active green dot |
| Status: attention required | Caution amber dot |
| Status: error / failure | Danger red dot, pulsing |
