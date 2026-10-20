import AppKit
import DesignKitCore

extension AppearanceChoice {
    /// `NSApplication.appearance` reaches every window, sheet and file dialog of the app at once.
    @MainActor
    public func apply() {
        NSApplication.shared.appearance = switch self {
        case .system: nil
        case .light: NSAppearance(named: .aqua)
        case .dark: NSAppearance(named: .darkAqua)
        }
    }
}
