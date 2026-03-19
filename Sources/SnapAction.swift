// SnapAction.swift
// MikaGrid
//
// Enum of all snap actions with geometry calculations and default key bindings.
// Swift 6.0 strict concurrency, macOS 14+

import AppKit
import Carbon

enum SnapAction: String, CaseIterable, Identifiable, Sendable {
    case leftHalf
    case rightHalf
    case topHalf
    case bottomHalf
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case maximize
    case center
    case restore

    var id: String { rawValue }

    var label: String {
        switch self {
        case .leftHalf:    return "Left Half"
        case .rightHalf:   return "Right Half"
        case .topHalf:     return "Top Half"
        case .bottomHalf:  return "Bottom Half"
        case .topLeft:     return "Top Left"
        case .topRight:    return "Top Right"
        case .bottomLeft:  return "Bottom Left"
        case .bottomRight: return "Bottom Right"
        case .maximize:    return "Maximize"
        case .center:      return "Center"
        case .restore:     return "Restore"
        }
    }

    var systemImage: String {
        switch self {
        case .leftHalf:    return "rectangle.lefthalf.filled"
        case .rightHalf:   return "rectangle.righthalf.filled"
        case .topHalf:     return "rectangle.tophalf.filled"
        case .bottomHalf:  return "rectangle.bottomhalf.filled"
        case .topLeft:     return "rectangle.inset.topleft.filled"
        case .topRight:    return "rectangle.inset.topright.filled"
        case .bottomLeft:  return "rectangle.inset.bottomleft.filled"
        case .bottomRight: return "rectangle.inset.bottomright.filled"
        case .maximize:    return "rectangle.fill"
        case .center:      return "rectangle.center.inset.filled"
        case .restore:     return "arrow.uturn.backward"
        }
    }

    var hotkeyID: UInt32 {
        switch self {
        case .leftHalf:    return 1
        case .rightHalf:   return 2
        case .topHalf:     return 3
        case .bottomHalf:  return 4
        case .topLeft:     return 5
        case .topRight:    return 6
        case .bottomLeft:  return 7
        case .bottomRight: return 8
        case .maximize:    return 9
        case .center:      return 10
        case .restore:     return 11
        }
    }

    var defaultBinding: HotkeyBinding {
        let ctrlOpt = UInt32(controlKey | optionKey)
        switch self {
        case .leftHalf:    return HotkeyBinding(keyCode: 0x7B, modifiers: ctrlOpt)  // ⌃⌥←
        case .rightHalf:   return HotkeyBinding(keyCode: 0x7C, modifiers: ctrlOpt)  // ⌃⌥→
        case .topHalf:     return HotkeyBinding(keyCode: 0x7E, modifiers: ctrlOpt)  // ⌃⌥↑
        case .bottomHalf:  return HotkeyBinding(keyCode: 0x7D, modifiers: ctrlOpt)  // ⌃⌥↓
        case .topLeft:     return HotkeyBinding(keyCode: 0x20, modifiers: ctrlOpt)  // ⌃⌥U
        case .topRight:    return HotkeyBinding(keyCode: 0x22, modifiers: ctrlOpt)  // ⌃⌥I
        case .bottomLeft:  return HotkeyBinding(keyCode: 0x26, modifiers: ctrlOpt)  // ⌃⌥J
        case .bottomRight: return HotkeyBinding(keyCode: 0x28, modifiers: ctrlOpt)  // ⌃⌥K
        case .maximize:    return HotkeyBinding(keyCode: 0x24, modifiers: ctrlOpt)  // ⌃⌥↩
        case .center:      return HotkeyBinding(keyCode: 0x08, modifiers: ctrlOpt)  // ⌃⌥C
        case .restore:     return HotkeyBinding(keyCode: 0x33, modifiers: ctrlOpt)  // ⌃⌥⌫
        }
    }

    /// Calculate target frame for this snap action on the given screen.
    /// Returns frame in AX coordinates (top-left origin).
    func targetFrame(on screen: NSScreen, currentFrame: CGRect) -> CGRect? {
        if self == .restore { return nil }

        let visible = screen.visibleFrame
        let screenFrame = screen.frame
        let mainScreenHeight = NSScreen.screens.first?.frame.height ?? screenFrame.height

        // Convert NSScreen visibleFrame (bottom-left origin) to AX coords (top-left origin)
        let axX = visible.origin.x
        let axY = mainScreenHeight - visible.origin.y - visible.height
        let w = visible.width
        let h = visible.height

        let rect: CGRect
        switch self {
        case .leftHalf:
            rect = CGRect(x: axX, y: axY, width: w / 2, height: h)
        case .rightHalf:
            rect = CGRect(x: axX + w / 2, y: axY, width: w / 2, height: h)
        case .topHalf:
            rect = CGRect(x: axX, y: axY, width: w, height: h / 2)
        case .bottomHalf:
            rect = CGRect(x: axX, y: axY + h / 2, width: w, height: h / 2)
        case .topLeft:
            rect = CGRect(x: axX, y: axY, width: w / 2, height: h / 2)
        case .topRight:
            rect = CGRect(x: axX + w / 2, y: axY, width: w / 2, height: h / 2)
        case .bottomLeft:
            rect = CGRect(x: axX, y: axY + h / 2, width: w / 2, height: h / 2)
        case .bottomRight:
            rect = CGRect(x: axX + w / 2, y: axY + h / 2, width: w / 2, height: h / 2)
        case .maximize:
            rect = CGRect(x: axX, y: axY, width: w, height: h)
        case .center:
            let centerW = w * 2 / 3
            let centerH = h * 2 / 3
            rect = CGRect(
                x: axX + (w - centerW) / 2,
                y: axY + (h - centerH) / 2,
                width: centerW,
                height: centerH
            )
        case .restore:
            return nil
        }

        return rect
    }
}
