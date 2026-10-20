import Foundation

/// The appearance setting: follow the system, or force light or dark for every window of the app. Stored in
/// `UserDefaults` only; `DesignKitUI` applies it to `NSApp.appearance`, which reaches windows, sheets and file dialogs
/// alike.
public enum AppearanceChoice: String, CaseIterable, Sendable, Identifiable {
    case system
    case light
    case dark

    public static let defaultsKey = "appearance"

    public var id: String { rawValue }

    /// `nil` follows the system.
    public var forcedPalette: PaletteAppearance? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }

    /// System until the user chooses; a stored value nobody defined counts as System, never as a crash.
    public static func stored(in defaults: UserDefaults = .standard) -> AppearanceChoice {
        defaults.string(forKey: defaultsKey).flatMap(AppearanceChoice.init(rawValue:)) ?? .system
    }

    public func store(in defaults: UserDefaults = .standard) {
        defaults.set(rawValue, forKey: Self.defaultsKey)
    }
}
