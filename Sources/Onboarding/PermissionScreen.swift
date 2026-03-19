// PermissionScreen.swift
// MikaGrid
//
// Onboarding screen 2: Accessibility permission request.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct PermissionScreen: View {
    let appState: AppState
    let onNext: () -> Void

    @State private var autoAdvanceTask: Task<Void, Never>?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if appState.accessibilityManager.isGranted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.green)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: "lock.shield")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.MikaPlus.tealPrimary)
            }

            Text("Accessibility Permission")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.MikaPlus.textPrimary)

            Text("Mika+Grid needs Accessibility access to move and resize windows. Your data stays on your Mac.")
                .font(.system(size: 13))
                .foregroundStyle(Color.MikaPlus.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 340)

            if !appState.accessibilityManager.isGranted {
                Button {
                    appState.accessibilityManager.openSystemSettings()
                } label: {
                    Text("Open System Settings")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.MikaPlus.tealPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }

            Spacer()

            if !appState.accessibilityManager.isGranted {
                Button("Skip for now") {
                    appState.preferences.permissionSkipped = true
                    onNext()
                }
                .buttonStyle(.plain)
                .font(.system(size: 12))
                .foregroundStyle(Color.MikaPlus.tealLight.opacity(0.5))
            }

            Spacer()
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut, value: appState.accessibilityManager.isGranted)
        .onAppear {
            appState.accessibilityManager.startPolling()
        }
        .onDisappear {
            appState.accessibilityManager.stopPolling()
            autoAdvanceTask?.cancel()
        }
        .onReceive(timer) { _ in
            if appState.accessibilityManager.isGranted {
                autoAdvanceTask = Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1))
                    if !Task.isCancelled {
                        onNext()
                    }
                }
            }
        }
    }
}
