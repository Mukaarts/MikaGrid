// SnapHistory.swift
// MikaGrid
//
// Stores previous window positions for the Restore action.
// Swift 6.0 strict concurrency, macOS 14+

import Foundation

@MainActor
final class SnapHistory {
    private var positions: [String: CGRect] = [:]

    func savePosition(_ frame: CGRect, for key: String) {
        positions[key] = frame
    }

    func getPosition(for key: String) -> CGRect? {
        positions[key]
    }

    func clearAll() {
        positions.removeAll()
    }
}
