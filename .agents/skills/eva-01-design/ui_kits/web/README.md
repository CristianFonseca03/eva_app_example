# EVA-01 Web UI Kit — NERV Operations Console

A desktop-first prototype recreating the operational dashboard of the EVA-01 design system.

## What this kit demonstrates
- Top nav bar with system status indicators
- Left sidebar navigation (240px) with subsystem links
- Main content area: status panel grid with live-feel data
- Right rail telemetry feed (280px)
- Detail view with breadcrumb, action panel, alert banner
- Interactive: navigating sidebar items swaps the central view

## Files
- `index.html` — entry, mounts the React tree
- `App.jsx` — top-level shell, routes between dashboard / detail
- `TopBar.jsx`, `Sidebar.jsx`, `RightRail.jsx` — chrome
- `Dashboard.jsx`, `DetailView.jsx` — main views
- `components.jsx` — buttons, inputs, badges, cards, progress

## How to run
Open `index.html` in the preview pane.
