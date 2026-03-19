// GeneralTabView.swift
// MikaGrid
//
// General preferences: Launch at Login, animations, etc.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct GeneralTabView: View {
    let appState: AppState

    @State private var launchAtLogin = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("General")
                .font(.title2.bold())

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Launch Mika+Grid at login", isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            appState.launchAtLoginManager.setEnabled(newValue)
                        }

                    Divider()

                    Toggle("Enable snap animations", isOn: Bindable(appState.preferences).animationsEnabled)

                    Divider()

                    // Accessibility status
                    HStack {
                        Label(
                            appState.accessibilityManager.isGranted ? "Accessibility: Granted" : "Accessibility: Not Granted",
                            systemImage: appState.accessibilityManager.isGranted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
                        )
                        .foregroundStyle(appState.accessibilityManager.isGranted ? .green : .orange)

                        Spacer()

                        if !appState.accessibilityManager.isGranted {
                            Button("Open Settings") {
                                appState.accessibilityManager.openSystemSettings()
                            }
                        }
                    }
                }
                .padding(4)
            }

            Spacer()
        }
        .onAppear {
            launchAtLogin = appState.launchAtLoginManager.isEnabled
            appState.accessibilityManager.checkPermission()
        }
    }
}
