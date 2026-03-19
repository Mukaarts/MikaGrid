# Changelog

## [1.1.0] - 2026-03-19

### Added
- **Sparkle Auto-Update** — integrated Sparkle 2.6+ for automatic update checks via menubar and preferences
- **Check for Updates** — "Updates" button in popover footer and "Check Now" in General preferences
- **Automatic Updates Toggle** — configurable in Preferences > General
- **appcast.xml** — GitHub-hosted update feed with EdDSA signature verification
- **Sparkle Framework Embedding** — build script embeds and signs Sparkle.framework with nested components

### Changed
- Package.swift: added Sparkle dependency
- Info.plist: added `SUFeedURL` and `SUPublicEDKey` for Sparkle
- Build script: embeds Sparkle.framework with inside-out codesigning
- Popover footer: "About" replaced with "Updates" button

## [1.0.0] - 2026-03-19

### Added
- **Menubar App** — native macOS menu bar app with `MenuBarExtra(.window)`, no Dock icon (`LSUIElement`)
- **Visual Snap Grid** — popover with clickable zones showing miniature monitor previews and shortcut labels; hover effects with Mika+ teal branding
- **Window Snapping** — AXUIElement-based window manipulation with 11 snap actions: Left/Right/Top/Bottom Half, four Quarters, Maximize, Center (2/3), and Restore
- **Multi-Monitor Support** — determines target screen by window center point; coordinate conversion between AX (top-left origin) and NSScreen (bottom-left origin)
- **Window Restore** — saves previous window position before each snap; ⌃⌥⌫ restores the original frame (keyed by PID + window title)
- **Global Hotkeys** — Carbon `RegisterEventHotKey` with signature `0x4D4B4744` ("MKGD"); 11 default bindings on ⌃⌥ + arrow/letter keys
- **Customizable Shortcuts** — inline shortcut recorder in Preferences with conflict detection and restore-defaults
- **Accessibility Permission** — `AXIsProcessTrusted()` check with guided permission request; polling timer for onboarding auto-advance; deep link to System Settings
- **First Launch Onboarding** — 3-screen guided flow: Welcome ("Snap. Organize. Focus."), Accessibility Permission with auto-polling, Shortcuts overview with Launch at Login toggle
- **Preferences Window** — 3-tab NavigationSplitView (General, Shortcuts, About) with NSWindow + NSHostingView pattern
- **General Preferences** — Launch at Login toggle (SMAppService), animation toggle, accessibility status indicator
- **About Tab** — version info, re-show onboarding, reset all settings with confirmation
- **About Window** — standalone branded window with Mika+ gradient background
- **Launch at Login** — SMAppService.mainApp integration
- **Mika+ Brand Colors** — shared color palette (`MikaPlusColors.swift`) matching the Mika+ ecosystem
- **App Icon** — custom 1024px icon with concentric rounded rectangles, crosshair, and "M+" badge
- **Build Pipeline** — SPM build + app bundle assembly + ad-hoc codesign (`scripts/build.sh`)
- **DMG Installer** — two scripts: `create-dmg.sh` (requires brew `create-dmg`) and `create-dmg-simple.sh` (built-in tools only); custom branded background with grid pattern
