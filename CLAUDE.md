# Mika+Grid — Claude Code Brief

## What is this?
A native macOS Menu Bar app built with Swift + SwiftUI.
It snaps windows to predefined layouts using the macOS Accessibility API — similar to Rectangle.
The app lives exclusively in the menu bar (no Dock icon).

## App Identity
- **Name**: Mika+Grid
- **Bundle ID**: lu.daumedia.mikagrid
- **Min macOS**: 13.0 (Ventura) — required for `MenuBarExtra`
- **Language**: Swift 5.9+, SwiftUI
- **Architecture**: arm64 + x86_64 (Universal)

## Project Structure
```
MikaGrid/
├── CLAUDE.md                        ← you are here
├── MikaGrid.xcodeproj/
│   └── project.pbxproj
└── MikaGrid/
    ├── MikaGridApp.swift            ← @main, MenuBarExtra scene
    ├── AppState.swift               ← ObservableObject, shared state
    ├── AppMenuView.swift            ← Popover UI
    ├── SettingsView.swift           ← Settings window (3 tabs)
    ├── GlobalShortcutMonitor.swift  ← NSEvent global key monitor
    ├── WindowSnapEngine.swift       ← Accessibility API window mover
    ├── Info.plist
    └── Assets.xcassets/
        └── AppIcon.appiconset/      ← already populated
```

## Features to implement

### 1. Menu Bar Popover (`AppMenuView.swift`)
- App header with icon + name + green status dot
- Quick Note text field (persisted via AppStorage)
- Snap action buttons: Left, Right, Top, Bottom, Maximize, Center
- Recent snaps history (last 3)
- Footer: Settings | Reload | Quit

### 2. Window Snapping (`WindowSnapEngine.swift`)
Use `AXUIElement` Accessibility API to move the frontmost window.
Supported layouts:
| Key | Layout |
|-----|--------|
| left | Left half |
| right | Right half |
| top | Top half |
| bottom | Bottom half |
| maximize | Full screen |
| center | 2/3 centered |
| topleft | Top-left quarter |
| topright | Top-right quarter |
| bottomleft | Bottom-left quarter |
| bottomright | Bottom-right quarter |
| first3rd | First third |
| center3rd | Center third |
| last3rd | Last third |
| first23rd | First two thirds |
| last23rd | Last two thirds |

Use `NSScreen.main?.visibleFrame` (excludes menu bar + Dock).
Convert NSScreen coords (bottom-left origin) → AX coords (top-left origin).

### 3. Global Shortcuts (`GlobalShortcutMonitor.swift`)
Use `NSEvent.addGlobalMonitorForEvents(matching: .keyDown)`.

| Shortcut | Action |
|----------|--------|
| ⌃← | left |
| ⌃→ | right |
| ⌃↑ | top |
| ⌃↓ | bottom |
| ⌃⇧↑ | maximize |
| ⌃C | center |
| ⌃⇧Q | topleft |
| ⌃⇧E | topright |
| ⌃⇧A | bottomleft |
| ⌃⇧D | bottomright |

### 4. Settings (`SettingsView.swift`)
Three tabs:
- **General**: Launch at Login (`SMAppService`), Show in Dock toggle, Clear History
- **Shortcuts**: Read-only list of all key bindings
- **Appearance**: Accent color picker (6 colors)

### 5. AppState (`AppState.swift`)
```swift
@AppStorage("accentColorIndex") var accentColorIndex: Int = 0
@AppStorage("launchAtLogin") var launchAtLogin: Bool = false
@AppStorage("showInDock") var showInDock: Bool = false
@AppStorage("quickNote") var quickNote: String = ""
@Published var history: [SnapEntry] = []
```

## Permissions Required
- **Accessibility**: `AXIsProcessTrusted()` — prompt user on first launch
- **NO App Sandbox** — required for Accessibility + global key monitor
- `LSUIElement = true` in Info.plist — hides from Dock

## Communication between components
Use `DistributedNotificationCenter` with name `com.daumedia.snap`:
```swift
// Post (from menu or shortcut monitor):
DistributedNotificationCenter.default().postNotificationName(
    Notification.Name("com.daumedia.snap"),
    object: "left",
    userInfo: nil,
    deliverImmediately: true
)

// Listen (in WindowSnapEngine):
DistributedNotificationCenter.default().addObserver(
    forName: Notification.Name("com.daumedia.snap"), ...
)
```

## Design Guidelines
- Follow macOS HIG
- Use `Color.accentColor` for interactive elements
- Menu popover width: 280pt
- Use SF Symbols for icons
- Dark mode compatible

## Build & Run
```bash
open MikaGrid.xcodeproj
# Then ⌘R in Xcode
```

On first launch:
1. App appears in menu bar
2. Prompts for Accessibility permission
3. System Settings → Privacy & Security → Accessibility → enable Mika+Grid

## What Claude Code should do
1. Generate `MikaGrid.xcodeproj/project.pbxproj` (valid Xcode project file)
2. Implement all `.swift` files listed above
3. Ensure the app compiles and runs on macOS 13+
4. Add proper error handling for Accessibility permission denial
5. Test that window snapping works for common apps (Safari, Terminal, Finder)
