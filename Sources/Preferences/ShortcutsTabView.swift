// ShortcutsTabView.swift
// MikaGrid
//
// Shortcuts preferences: hotkey list with inline recorder.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI
import Carbon

struct ShortcutsTabView: View {
    let appState: AppState

    @State private var bindings: [SnapAction: HotkeyBinding] = [:]
    @State private var recordingAction: SnapAction?
    @State private var conflictMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Shortcuts")
                .font(.title2.bold())

            GroupBox {
                VStack(spacing: 0) {
                    ForEach(Array(SnapAction.allCases.enumerated()), id: \.element.id) { index, action in
                        if index > 0 {
                            Divider()
                        }
                        HStack {
                            Label(action.label, systemImage: action.systemImage)
                            Spacer()
                            ShortcutRecorderView(
                                binding: bindings[action] ?? action.defaultBinding,
                                isRecording: recordingAction == action,
                                onStartRecording: {
                                    recordingAction = action
                                    conflictMessage = nil
                                },
                                onRecord: { newBinding in
                                    recordBinding(newBinding, for: action)
                                },
                                onCancel: {
                                    recordingAction = nil
                                }
                            )
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                    }
                }
            }

            if let conflict = conflictMessage {
                Label(conflict, systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            HStack {
                Spacer()
                Button {
                    restoreDefaults()
                } label: {
                    Label("Restore Defaults", systemImage: "arrow.counterclockwise")
                }
            }
        }
        .onAppear {
            bindings = appState.hotkeyManager?.currentBindings ?? [:]
        }
    }

    private func recordBinding(_ binding: HotkeyBinding, for action: SnapAction) {
        for (otherAction, otherBinding) in bindings where otherAction != action {
            if otherBinding == binding {
                conflictMessage = "Conflict with \"\(otherAction.label)\""
                recordingAction = nil
                return
            }
        }

        bindings[action] = binding
        recordingAction = nil
        conflictMessage = nil
        appState.hotkeyManager?.reRegisterAll(bindings: bindings)
    }

    private func restoreDefaults() {
        var defaults: [SnapAction: HotkeyBinding] = [:]
        for action in SnapAction.allCases {
            defaults[action] = action.defaultBinding
        }
        bindings = defaults
        conflictMessage = nil
        appState.hotkeyManager?.reRegisterAll(bindings: defaults)
    }
}

// MARK: - ShortcutRecorderView

struct ShortcutRecorderView: View {
    let binding: HotkeyBinding
    let isRecording: Bool
    let onStartRecording: () -> Void
    let onRecord: (HotkeyBinding) -> Void
    let onCancel: () -> Void

    @State private var keyMonitor: Any?

    var body: some View {
        Button {
            if isRecording {
                onCancel()
            } else {
                onStartRecording()
            }
        } label: {
            Text(isRecording ? "Press shortcut..." : binding.displayString)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(isRecording ? Color.accentColor : Color.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .frame(minWidth: 100)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.quaternary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(
                                    isRecording ? Color.accentColor : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                )
        }
        .buttonStyle(.plain)
        .onChange(of: isRecording) { _, newValue in
            if newValue {
                startMonitoring()
            } else {
                stopMonitoring()
            }
        }
    }

    private func startMonitoring() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            if event.keyCode == 53 {
                onCancel()
                return nil
            }

            let carbonModifiers = carbonModifiersFromNSEvent(event.modifierFlags)
            let hasCmdOrCtrl = event.modifierFlags.contains(.command) || event.modifierFlags.contains(.control)
            guard hasCmdOrCtrl else { return nil }

            let newBinding = HotkeyBinding(
                keyCode: UInt32(event.keyCode),
                modifiers: carbonModifiers
            )
            onRecord(newBinding)
            return nil
        }
    }

    private func stopMonitoring() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }

    private func carbonModifiersFromNSEvent(_ flags: NSEvent.ModifierFlags) -> UInt32 {
        var carbon: UInt32 = 0
        if flags.contains(.command) { carbon |= UInt32(cmdKey) }
        if flags.contains(.shift)   { carbon |= UInt32(shiftKey) }
        if flags.contains(.control) { carbon |= UInt32(controlKey) }
        if flags.contains(.option)  { carbon |= UInt32(optionKey) }
        return carbon
    }
}
