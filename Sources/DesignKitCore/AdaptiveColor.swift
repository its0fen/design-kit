import Foundation

/// One color in a light and a dark variant; the view layer picks by appearance.
public struct AdaptiveColor: Sendable, Equatable {
    public let name: String
    public let light: RGBColor
    public let dark: RGBColor

    public init(_ name: String, light: String, dark: String) {
        self.name = name
        // Literals below only; a typo should fail loudly on first use.
        self.light = RGBColor(hex: light)!
        self.dark = RGBColor(hex: dark)!
    }

    public func resolved(for appearance: PaletteAppearance) -> RGBColor {
        appearance == .light ? light : dark
    }
}

public enum PaletteAppearance: Sendable, CaseIterable {
    case light, dark
}

/// What a status color means, so a view never names a hue.
public enum StatusTone: Sendable, CaseIterable {
    case positive, negative, warning, neutral
}
