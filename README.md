# Mika+Grid v1.0.0

A lightweight macOS menubar window manager that snaps windows to predefined layouts using keyboard shortcuts or a visual grid — similar to Rectangle, built natively with Swift and SwiftUI. Part of the Mika+ ecosystem.

## Features

- **Menubar App** — lives in your menubar, no Dock icon (`LSUIElement`)
- **Visual Snap Grid** — click any zone in the popover to snap the frontmost window
- **11 Snap Actions** — halves, quarters, maximize, center (2/3), and restore
- **Global Hotkeys** — Carbon-based `RegisterEventHotKey` with customizable bindings
- **Multi-Monitor Support** — snaps to the screen where the window center is located
- **Window Restore** — remembers previous positions, undo any snap with ⌃⌥⌫
- **Accessibility Permission** — guided onboarding with AXIsProcessTrusted polling
- **First Launch Onboarding** — 3-screen flow (welcome, permissions, shortcuts overview)
- **Preferences Window** — 3-tab settings (General, Shortcuts, About)
- **Shortcut Recorder** — inline hotkey recorder with conflict detection
- **Launch at Login** — via SMAppService (macOS 13+)
- **Mika+ Branding** — dark theme with teal accent colors

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Opt+←` | Left Half |
| `Ctrl+Opt+→` | Right Half |
| `Ctrl+Opt+↑` | Top Half |
| `Ctrl+Opt+↓` | Bottom Half |
| `Ctrl+Opt+U` | Top Left Quarter |
| `Ctrl+Opt+I` | Top Right Quarter |
| `Ctrl+Opt+J` | Bottom Left Quarter |
| `Ctrl+Opt+K` | Bottom Right Quarter |
| `Ctrl+Opt+↩` | Maximize |
| `Ctrl+Opt+C` | Center (2/3) |
| `Ctrl+Opt+⌫` | Restore Previous Position |

All shortcuts are reconfigurable in Preferences > Shortcuts.

## Requirements

- macOS 14.0 (Sonoma) or later
- Accessibility permission (prompted on first launch)

## Build

```bash
./build.sh
```

This compiles the project via SPM, assembles the `.app` bundle, and signs with hardened runtime.

Use `./build.sh --clean` to clean the `.build/` directory before compiling.

## Install

```bash
cp -r "build/Mika+Grid.app" /Applications/
```

## Run

```bash
open "build/Mika+Grid.app"
```

On first launch:
1. App appears in the menubar (grid icon)
2. Onboarding guides you through Accessibility permission
3. System Settings > Privacy & Security > Accessibility > enable Mika+Grid

> **Note:** Always run via the `.app` bundle, not `swift run`, to ensure proper bundle identifier and hotkey registration.

## Distribution

### Create DMG Installer

**Professional DMG** (with custom background and layout):

```bash
brew install create-dmg  # one-time prerequisite
bash scripts/create-dmg.sh
```

**Simple DMG** (no dependencies, uses only hdiutil):

```bash
bash scripts/create-dmg-simple.sh
```

Both output to `installer/Mika+Grid-v{VERSION}.dmg`.

### DMG Background

Regenerate the branded DMG background images:

```bash
swift scripts/GenerateDMGBackground.swift
```

## Project Structure

```
Sources/
├── MikaGridApp.swift                 # @main App + AppDelegate
├── AppState.swift                    # Central observable state
├── AppPreferences.swift              # UserDefaults-backed preferences
├── MikaPlusColors.swift              # Mika+ brand color palette
├── LaunchAtLoginManager.swift        # SMAppService wrapper
├── AboutWindow.swift                 # About window with branding
├── WindowManager.swift               # AXUIElement window manipulation
├── SnapAction.swift                  # 11 snap actions with geometry
├── SnapHistory.swift                 # Previous positions for restore
├── AccessibilityManager.swift        # Permission check/request/polling
├── HotkeyManager.swift               # Carbon global hotkeys
├── PopoverGridView.swift             # Menubar popover with snap grid
├── SnapZoneButton.swift              # Clickable zone with monitor preview
├── Preferences/
│   ├── PreferencesStyles.swift       # Tab enum
│   ├── PreferencesWindowController.swift
│   ├── PreferencesContainerView.swift
│   ├── GeneralTabView.swift          # Launch at Login, animations
│   ├── ShortcutsTabView.swift        # Inline shortcut recorder
│   └── AboutTabView.swift            # Version, reset, re-show onboarding
└── Onboarding/
    ├── OnboardingWindowController.swift
    ├── OnboardingView.swift          # Paged container
    ├── WelcomeScreen.swift           # "Snap. Organize. Focus."
    ├── PermissionScreen.swift        # Accessibility with auto-polling
    └── ShortcutsScreen.swift         # Shortcut overview + Launch at Login
```

## License

[MIT](LICENSE)
