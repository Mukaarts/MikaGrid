// PopoverGridView.swift
// MikaGrid
//
// Main popover UI: visual snap grid with monitor previews.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct PopoverGridView: View {
    let appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)

            // Accessibility warning
            if !appState.accessibilityManager.isGranted {
                accessibilityWarning
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }

            Divider()
                .padding(.horizontal, 12)

            // Snap Grid
            snapGrid
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            Divider()
                .padding(.horizontal, 12)

            // Footer
            footerView
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
        .frame(width: 280)
        .onAppear {
            appState.accessibilityManager.checkPermission()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "square.grid.3x3.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.MikaPlus.tealPrimary)

            Text("Mika+Grid")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer()

            Circle()
                .fill(appState.accessibilityManager.isGranted ? Color.green : Color.orange)
                .frame(width: 8, height: 8)
        }
    }

    // MARK: - Accessibility Warning

    private var accessibilityWarning: some View {
        Button {
            appState.accessibilityManager.openSystemSettings()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(.orange)
                Text("Accessibility permission required")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Snap Grid

    private var snapGrid: some View {
        VStack(spacing: 8) {
            // Row 1: Halves
            HStack(spacing: 8) {
                SnapZoneButton(action: .leftHalf, appState: appState)
                SnapZoneButton(action: .rightHalf, appState: appState)
            }

            // Row 2: Top/Bottom halves
            HStack(spacing: 8) {
                SnapZoneButton(action: .topHalf, appState: appState)
                SnapZoneButton(action: .bottomHalf, appState: appState)
            }

            // Row 3: Quarters
            HStack(spacing: 8) {
                SnapZoneButton(action: .topLeft, appState: appState)
                SnapZoneButton(action: .topRight, appState: appState)
            }
            HStack(spacing: 8) {
                SnapZoneButton(action: .bottomLeft, appState: appState)
                SnapZoneButton(action: .bottomRight, appState: appState)
            }

            // Row 4: Maximize, Center, Restore
            HStack(spacing: 8) {
                SnapZoneButton(action: .maximize, appState: appState)
                SnapZoneButton(action: .center, appState: appState)
                SnapZoneButton(action: .restore, appState: appState)
            }
        }
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack {
            Button("Preferences") {
                NotificationCenter.default.post(name: .showPreferences, object: nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)

            Spacer()

            Button("Updates") {
                appState.sparkleUpdater.checkForUpdates()
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)

            Spacer()

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let showPreferences = Notification.Name("showPreferences")
    static let showAbout = Notification.Name("showAbout")
}
