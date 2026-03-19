// PreferencesWindowController.swift
// MikaGrid
//
// Native macOS preferences window controller.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

@MainActor
final class PreferencesWindowController: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    private let appState: AppState
    private let onShowOnboarding: () -> Void

    init(appState: AppState, onShowOnboarding: @escaping () -> Void) {
        self.appState = appState
        self.onShowOnboarding = onShowOnboarding
    }

    func showWindow() {
        if let existing = window, existing.isVisible {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate()
            return
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 580, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Mika+Grid Settings"
        window.isReleasedWhenClosed = false
        window.delegate = self

        let contentView = PreferencesContainerView(
            appState: appState,
            onShowOnboarding: onShowOnboarding
        )
        window.contentView = NSHostingView(rootView: contentView)
        window.center()

        self.window = window

        NSApp.activate()
        window.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
