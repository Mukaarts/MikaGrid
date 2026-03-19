// SnapZoneButton.swift
// MikaGrid
//
// Individual clickable snap zone with miniature monitor preview.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct SnapZoneButton: View {
    let action: SnapAction
    let appState: AppState

    @State private var isHovering = false

    var body: some View {
        Button {
            appState.windowManager?.snapFrontmostWindow(to: action)
        } label: {
            VStack(spacing: 4) {
                // Miniature monitor with highlighted zone
                ZStack {
                    // Monitor outline
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                        .frame(width: monitorWidth, height: monitorHeight)

                    // Highlighted snap zone
                    highlightedZone
                }
                .frame(width: monitorWidth, height: monitorHeight)

                // Label
                Text(action.label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)

                // Shortcut text
                if let binding = appState.hotkeyManager?.currentBindings[action] {
                    Text(binding.displayString)
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(Color.MikaPlus.tealLight.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovering ? Color.MikaPlus.tealPrimary.opacity(0.15) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private var monitorWidth: CGFloat { 40 }
    private var monitorHeight: CGFloat { 26 }

    @ViewBuilder
    private var highlightedZone: some View {
        let color = isHovering ? Color.MikaPlus.tealPrimary : Color.MikaPlus.tealPrimary.opacity(0.4)

        switch action {
        case .leftHalf:
            HStack(spacing: 0) {
                color.frame(width: monitorWidth / 2)
                Color.clear
            }
        case .rightHalf:
            HStack(spacing: 0) {
                Color.clear
                color.frame(width: monitorWidth / 2)
            }
        case .topHalf:
            VStack(spacing: 0) {
                color.frame(height: monitorHeight / 2)
                Color.clear
            }
        case .bottomHalf:
            VStack(spacing: 0) {
                Color.clear
                color.frame(height: monitorHeight / 2)
            }
        case .topLeft:
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color.frame(width: monitorWidth / 2, height: monitorHeight / 2)
                    Color.clear
                }
                Color.clear
            }
        case .topRight:
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Color.clear
                    color.frame(width: monitorWidth / 2, height: monitorHeight / 2)
                }
                Color.clear
            }
        case .bottomLeft:
            VStack(spacing: 0) {
                Color.clear
                HStack(spacing: 0) {
                    color.frame(width: monitorWidth / 2, height: monitorHeight / 2)
                    Color.clear
                }
            }
        case .bottomRight:
            VStack(spacing: 0) {
                Color.clear
                HStack(spacing: 0) {
                    Color.clear
                    color.frame(width: monitorWidth / 2, height: monitorHeight / 2)
                }
            }
        case .maximize:
            color
        case .center:
            color
                .padding(4)
        case .restore:
            Image(systemName: "arrow.uturn.backward")
                .font(.system(size: 12))
                .foregroundStyle(color)
        }
    }
}
