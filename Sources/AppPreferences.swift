// AppPreferences.swift
// MikaGrid
//
// User preferences backed by UserDefaults.
// Swift 6.0 strict concurrency, macOS 14+

import Foundation

@Observable
@MainActor
final class AppPreferences {
    private let defaults = UserDefaults.standard

    var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }

    var permissionSkipped: Bool {
        didSet { defaults.set(permissionSkipped, forKey: "permissionSkipped") }
    }

    var animationsEnabled: Bool {
        didSet { defaults.set(animationsEnabled, forKey: "animationsEnabled") }
    }

    init() {
        self.hasCompletedOnboarding = defaults.object(forKey: "hasCompletedOnboarding") as? Bool ?? false
        self.permissionSkipped = defaults.object(forKey: "permissionSkipped") as? Bool ?? false
        self.animationsEnabled = defaults.object(forKey: "animationsEnabled") as? Bool ?? true
    }

    func resetAllPreferences() {
        let allKeys = [
            "hasCompletedOnboarding", "permissionSkipped", "animationsEnabled",
            "hotkeyBindings",
        ]
        for key in allKeys {
            defaults.removeObject(forKey: key)
        }

        LaunchAtLoginManager().setEnabled(false)

        hasCompletedOnboarding = true
        permissionSkipped = false
        animationsEnabled = true
    }
}
