import AppKit
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark, sepia, nord
    var id: String { rawValue }
    var title: String { L10n.text("theme.\(rawValue)") }

    func resolved(systemIsDark: Bool) -> AppTheme {
        self == .system ? (systemIsDark ? .dark : .light) : self
    }

    var isDark: Bool { self == .dark || self == .nord }
}

/// Shared invalidation for every note surface, without rebuilding windows or editors.
final class DisplayPreferences: ObservableObject {
    static let shared = DisplayPreferences()
    @Published private(set) var revision = 0
    private var appearanceObservation: NSKeyValueObservation?

    var resolvedTheme: AppTheme {
        Settings.theme.resolved(systemIsDark:
            NSApp?.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua)
    }

    func start() {
        applyAppearance()
        appearanceObservation = NSApp.observe(\.effectiveAppearance, options: [.new]) { [weak self] _, _ in
            guard Settings.theme == .system else { return }
            self?.revision += 1
        }
    }

    func refresh() {
        applyAppearance()
        revision += 1
    }

    private func applyAppearance() {
        guard let app = NSApp else { return }
        let theme = Settings.theme
        app.appearance = theme == .system ? nil : NSAppearance(named: theme.isDark ? .darkAqua : .aqua)
    }
}
