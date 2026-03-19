// AboutTabView.swift
// MikaGrid
//
// About tab in preferences: version info, reset, show onboarding.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct AboutTabView: View {
    let appState: AppState
    let onShowOnboarding: () -> Void

    @State private var showResetConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About")
                .font(.title2.bold())

            GroupBox {
                VStack(spacing: 16) {
                    // App Icon
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.MikaPlus.tealPrimary)

                    Text("Mika+Grid")
                        .font(.system(size: 18, weight: .semibold))

                    Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Text("Part of the Mika+ ecosystem")
                        .font(.system(size: 11).italic())
                        .foregroundStyle(Color.MikaPlus.tealLight)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        onShowOnboarding()
                    } label: {
                        Label("Show Onboarding Again", systemImage: "arrow.clockwise")
                    }

                    Divider()

                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Label("Reset All Settings", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }
                .padding(4)
            }
            .alert("Reset All Settings?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    appState.preferences.resetAllPreferences()

                    // Re-register defaults
                    var defaults: [SnapAction: HotkeyBinding] = [:]
                    for action in SnapAction.allCases {
                        defaults[action] = action.defaultBinding
                    }
                    appState.hotkeyManager?.reRegisterAll(bindings: defaults)
                }
            } message: {
                Text("This will reset all shortcuts and preferences to their defaults.")
            }

            Spacer()
        }
    }
}
