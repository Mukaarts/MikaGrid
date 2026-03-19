// WindowManager.swift
// MikaGrid
//
// AXUIElement-based window manipulation for snapping.
// Swift 6.0 strict concurrency, macOS 14+

import AppKit
import ApplicationServices

@MainActor
final class WindowManager {
    private let snapHistory: SnapHistory

    init(snapHistory: SnapHistory) {
        self.snapHistory = snapHistory
    }

    func snapFrontmostWindow(to action: SnapAction) {
        guard let frontApp = NSWorkspace.shared.frontmostApplication else { return }
        let appElement = AXUIElementCreateApplication(frontApp.processIdentifier)

        var windowValue: AnyObject?
        guard AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &windowValue) == .success else {
            return
        }
        let window = windowValue as! AXUIElement

        // Get current position and size
        guard let currentFrame = getWindowFrame(window) else { return }

        // For restore action, use saved position
        if action == .restore {
            let key = windowKey(pid: frontApp.processIdentifier, window: window)
            if let savedFrame = snapHistory.getPosition(for: key) {
                setWindowFrame(window, frame: savedFrame)
            }
            return
        }

        // Determine which screen the window center is on
        let screen = screenForWindow(currentFrame)

        // Save current position before snapping
        let key = windowKey(pid: frontApp.processIdentifier, window: window)
        snapHistory.savePosition(currentFrame, for: key)

        // Calculate target frame
        guard let targetFrame = action.targetFrame(on: screen, currentFrame: currentFrame) else { return }

        setWindowFrame(window, frame: targetFrame)
    }

    // MARK: - Private

    private func getWindowFrame(_ window: AXUIElement) -> CGRect? {
        var posValue: AnyObject?
        var sizeValue: AnyObject?

        guard AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &posValue) == .success,
              AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeValue) == .success
        else { return nil }

        var position = CGPoint.zero
        var size = CGSize.zero
        AXValueGetValue(posValue as! AXValue, .cgPoint, &position)
        AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)

        return CGRect(origin: position, size: size)
    }

    private func setWindowFrame(_ window: AXUIElement, frame: CGRect) {
        var position = frame.origin
        var size = frame.size

        if let posValue = AXValueCreate(.cgPoint, &position) {
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posValue)
        }
        if let sizeValue = AXValueCreate(.cgSize, &size) {
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
        }
    }

    private func screenForWindow(_ frame: CGRect) -> NSScreen {
        let windowCenter = CGPoint(x: frame.midX, y: frame.midY)
        let mainScreenHeight = NSScreen.screens.first?.frame.height ?? 0

        // Convert AX center (top-left origin) to NSScreen coords (bottom-left origin)
        let cocoaCenter = CGPoint(x: windowCenter.x, y: mainScreenHeight - windowCenter.y)

        for screen in NSScreen.screens {
            if screen.frame.contains(cocoaCenter) {
                return screen
            }
        }
        return NSScreen.main ?? NSScreen.screens.first!
    }

    private func windowKey(pid: pid_t, window: AXUIElement) -> String {
        var titleValue: AnyObject?
        AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleValue)
        let title = (titleValue as? String) ?? "untitled"
        return "\(pid)_\(title)"
    }
}
