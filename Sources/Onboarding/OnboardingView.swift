// OnboardingView.swift
// MikaGrid
//
// SwiftUI container for onboarding flow with paged navigation.
// Swift 6.0 strict concurrency, macOS 14+

import SwiftUI

struct OnboardingView: View {
    let appState: AppState
    let onDismiss: () -> Void

    @State private var currentPage = 0

    private var needsPermission: Bool {
        !appState.accessibilityManager.isGranted
    }

    private var pageCount: Int {
        needsPermission ? 3 : 2
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                WelcomeScreen {
                    withAnimation { currentPage = 1 }
                }
                .tag(0)

                if needsPermission {
                    PermissionScreen(appState: appState) {
                        withAnimation { currentPage = 2 }
                    }
                    .tag(1)

                    ShortcutsScreen(
                        appState: appState,
                        onDismiss: onDismiss
                    )
                    .tag(2)
                } else {
                    ShortcutsScreen(
                        appState: appState,
                        onDismiss: onDismiss
                    )
                    .tag(1)
                }
            }
            .tabViewStyle(.automatic)

            // Dot indicators
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.MikaPlus.tealPrimary : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(width: 480, height: 560)
        .background(
            LinearGradient(
                colors: [Color.MikaPlus.darkBgDeep, Color.MikaPlus.darkBg],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onKeyPress(.escape) {
            onDismiss()
            return .handled
        }
    }
}
