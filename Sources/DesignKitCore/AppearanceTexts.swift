import Foundation

/// The only place the appearance choices get their (German) names, so a language switch has one file to change.
extension AppearanceChoice {
    public var title: String {
        switch self {
        case .system: "System"
        case .light: "Hell"
        case .dark: "Dunkel"
        }
    }
}
