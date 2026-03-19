// MikaGridApp.swift
// MikaGrid
//
// @main App with MenuBarExtra and AppDelegate for window management.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

@main
struct MikaGridApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            PopoverGridView(appState: appDelegate.appState)
        } label: {
            Image(systemName: "square.grid.3x3")
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - AppDelegate

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let appState = AppState()

    private var preferencesController: PreferencesWindowController?
    private var onboardingController: OnboardingWindowController?
    private var aboutController: AboutWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        appState.setup()

        // Show onboarding on first launch
        if !appState.preferences.hasCompletedOnboarding {
            showOnboarding()
        } else if !appState.preferences.permissionSkipped {
            // Check accessibility after onboarding was completed
            appState.accessibilityManager.checkPermission()
            if !appState.accessibilityManager.isGranted {
                appState.accessibilityManager.requestPermission()
            }
        }

        // Listen for notifications from popover
        NotificationCenter.default.addObserver(
            forName: .showPreferences, object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.showPreferences()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .showAbout, object: nil, queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.showAbout()
            }
        }
    }

    private func showOnboarding() {
        let controller = OnboardingWindowController(appState: appState)
        self.onboardingController = controller
        controller.showWindow()
    }

    private func showPreferences() {
        if preferencesController == nil {
            preferencesController = PreferencesWindowController(
                appState: appState,
                onShowOnboarding: { [weak self] in
                    self?.showOnboarding()
                }
            )
        }
        preferencesController?.showWindow()
    }

    private func showAbout() {
        if aboutController == nil {
            aboutController = AboutWindowController()
        }
        aboutController?.showWindow()
    }
}
