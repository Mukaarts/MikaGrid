// AppState.swift
// MikaGrid
//
// Central observable state for the app.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

@Observable
@MainActor
final class AppState {
    let preferences = AppPreferences()
    let launchAtLoginManager = LaunchAtLoginManager()
    let accessibilityManager = AccessibilityManager()
    let snapHistory = SnapHistory()

    var windowManager: WindowManager?
    var hotkeyManager: HotkeyManager?

    func setup() {
        let wm = WindowManager(snapHistory: snapHistory)
        self.windowManager = wm

        self.hotkeyManager = HotkeyManager { [weak wm] action in
            wm?.snapFrontmostWindow(to: action)
        }
    }
}
