// ShortcutsScreen.swift
// MikaGrid
//
// Onboarding screen 3: Keyboard shortcuts overview and launch-at-login toggle.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct ShortcutsScreen: View {
    let appState: AppState
    let onDismiss: () -> Void

    @State private var launchAtLogin = true

    private let shortcuts: [(keys: String, label: String)] = [
        ("⌃⌥←", "Left Half"),
        ("⌃⌥→", "Right Half"),
        ("⌃⌥↑", "Top Half"),
        ("⌃⌥↓", "Bottom Half"),
        ("⌃⌥U", "Top Left"),
        ("⌃⌥I", "Top Right"),
        ("⌃⌥J", "Bottom Left"),
        ("⌃⌥K", "Bottom Right"),
        ("⌃⌥↩", "Maximize"),
        ("⌃⌥C", "Center"),
        ("⌃⌥⌫", "Restore"),
    ]

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 8)

            Text("Keyboard Shortcuts")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.MikaPlus.textPrimary)

            ScrollView {
                VStack(spacing: 6) {
                    ForEach(shortcuts, id: \.keys) { shortcut in
                        HStack {
                            Text(shortcut.keys)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundStyle(Color.MikaPlus.tealLight)
                                .frame(width: 80, alignment: .trailing)
                            Text(shortcut.label)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.MikaPlus.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
                .padding(.horizontal, 40)
            }
            .frame(maxHeight: 300)

            Spacer()

            Toggle("Launch Mika+Grid at login", isOn: $launchAtLogin)
                .toggleStyle(.checkbox)
                .font(.system(size: 13))
                .foregroundStyle(Color.MikaPlus.textPrimary)
                .padding(.horizontal, 40)

            Button {
                appState.launchAtLoginManager.setEnabled(launchAtLogin)
                appState.preferences.hasCompletedOnboarding = true
                onDismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 40)
                    .background(Color.MikaPlus.tealPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)

            Spacer()
                .frame(height: 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
