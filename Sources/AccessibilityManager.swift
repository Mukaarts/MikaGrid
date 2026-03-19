// AccessibilityManager.swift
// MikaGrid
//
// Accessibility permission check and request.
// Swift 6.0 strict concurrency, macOS 14+

import AppKit
@preconcurrency import ApplicationServices

@Observable
@MainActor
final class AccessibilityManager {
    private(set) var isGranted: Bool = false
    private var pollTimer: Timer?

    init() {
        checkPermission()
    }

    func checkPermission() {
        isGranted = AXIsProcessTrusted()
    }

    func requestPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    func startPolling() {
        stopPolling()
        pollTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkPermission()
            }
        }
    }

    func stopPolling() {
        pollTimer?.invalidate()
        pollTimer = nil
    }
}
