---
name: eva-01-design
description: Use this skill to generate well-branded interfaces and assets for the EVA-01 design system — a NERV/Evangelion-inspired operational UI for multiplatform apps (iOS, Android, responsive web). Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping. This system is dark-only, angular, and uses orange as the workhorse color with red reserved for genuine destructive actions.
user-invocable: true
---

Read the README.md file within this skill, and explore the other available files.

If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

Key reference files:
- `README.md` — full system overview, content fundamentals, visual foundations, iconography
- `colors_and_type.css` — every design token (colors, type, spacing, clips, glows)
- `assets/` — logo, hazard pattern, 12 angular SVG icons
- `ui_kits/web/` — desktop dashboard reference, with reusable React components in `components.jsx`
- `ui_kits/mobile/` — phone-scale reference

When designing in this system:
1. Black backgrounds. No light mode. Never.
2. Orange (#FF6B00) is the default accent — buttons, borders, labels.
3. Red (#FF2020) is rationed — only for errors, destructive actions, critical alerts.
4. Hazard stripes only for irreversible actions; require typed-confirmation modal.
5. ALL CAPS for labels, buttons, status, headers. Sentence case only for paragraphs.
6. No emoji. Use the angular SVG icon set or unicode geometric chars.
7. No border-radius above 2px. Use `clip-path` diagonal cuts instead.
8. Letter-spacing 0.08–0.18em on all titles and ALL CAPS text.
9. Three font families: Share Tech Mono (data), Bebas Neue (display), Rajdhani (UI).
10. Honor `prefers-reduced-motion` — disable pulses, glitch, scan lines.
