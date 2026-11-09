import Foundation

/// A named set of colors to assign to items. Unlike `EarthPalette.tagColors`, the other sets are chosen for their look
/// and may sit close together; only their visibility on a card is checked.
public struct ColorPalette: Sendable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let colors: [AdaptiveColor]

    public init(id: String, name: String, colors: [AdaptiveColor]) {
        self.id = id
        self.name = name
        self.colors = colors
    }

    public static let earth = ColorPalette(id: "earth", name: "Erde", colors: EarthPalette.tagColors)

    public static let pastel = ColorPalette(id: "pastel", name: "Pastell", colors: [
        AdaptiveColor("Rosé", light: "E08A95", dark: "F4C2C8"),
        AdaptiveColor("Himmel", light: "78ACDC", dark: "B7D6F0"),
        AdaptiveColor("Vanille", light: "D4B65C", dark: "F0DFA6"),
        AdaptiveColor("Flieder", light: "A98DDA", dark: "D0C1EE"),
        AdaptiveColor("Minze", light: "6FBF98", dark: "B5E3CB"),
        AdaptiveColor("Pfirsich", light: "E89C72", dark: "F7CDB3"),
        AdaptiveColor("Aqua", light: "66BCC0", dark: "AEE1E3"),
        AdaptiveColor("Mauve", light: "C985BB", dark: "E6BEDF"),
        AdaptiveColor("Blattgrün", light: "93B385", dark: "C4D9BA"),
        AdaptiveColor("Koralle", light: "EC8A78", dark: "F7BFB3"),
        AdaptiveColor("Immergrün", light: "8A95D9", dark: "C1C7EE"),
        AdaptiveColor("Sand", light: "C0A684", dark: "E0D1BC"),
    ])

    public static let neon = ColorPalette(id: "neon", name: "Neon", colors: [
        AdaptiveColor("Pink", light: "FF2E93", dark: "FF5CAB"),
        AdaptiveColor("Cyan", light: "00A9C4", dark: "1AE5FF"),
        AdaptiveColor("Gelb", light: "C9B800", dark: "F5E600"),
        AdaptiveColor("Violett", light: "8A1CFF", dark: "AE66FF"),
        AdaptiveColor("Limette", light: "5FC400", dark: "8CFF1A"),
        AdaptiveColor("Orange", light: "FF6A00", dark: "FF8A33"),
        AdaptiveColor("Blau", light: "0A5CFF", dark: "4D8BFF"),
        AdaptiveColor("Magenta", light: "E600E6", dark: "FF4DFF"),
        AdaptiveColor("Grün", light: "00B35F", dark: "1AFF8C"),
        AdaptiveColor("Rot", light: "F01E2C", dark: "FF4D57"),
        AdaptiveColor("Türkis", light: "00A896", dark: "33F0DC"),
        AdaptiveColor("Indigo", light: "4B2EFF", dark: "7F6BFF"),
    ])

    public static let grayscale = ColorPalette(id: "grayscale", name: "Graustufen", colors: [
        AdaptiveColor("Schwarz", light: "222222", dark: "F2F2F2"),
        AdaptiveColor("Mittelgrau", light: "7A7A7A", dark: "A4A4A4"),
        AdaptiveColor("Anthrazit", light: "3A3A3A", dark: "DCDCDC"),
        AdaptiveColor("Silber", light: "A6A6A6", dark: "7C7C7C"),
        AdaptiveColor("Schiefergrau", light: "525252", dark: "C6C6C6"),
        AdaptiveColor("Hellgrau", light: "BEBEBE", dark: "686868"),
        AdaptiveColor("Dunkelgrau", light: "666666", dark: "B2B2B2"),
        AdaptiveColor("Nebel", light: "929292", dark: "909090"),
    ])

    public static let all = [earth, pastel, neon, grayscale]

    /// The palette color whose light variant is this hex.
    public static func color(lightHex: String) -> AdaptiveColor? {
        guard let wanted = RGBColor(hex: lightHex) else { return nil }
        return all.lazy.flatMap(\.colors).first { $0.light == wanted }
    }
}

extension AdaptiveColor {
    private static let minimumContrastOnDarkCard = 3.0
    private static let lighteningStep = 0.05

    /// A color someone picked by hand: as picked in light mode, and in dark mode lightened just enough to stand out on a
    /// card. `lightHex` must be six hex digits.
    public init?(pickedHex lightHex: String) {
        guard let light = RGBColor(hex: lightHex) else { return nil }
        let dark = Self.liftedForDarkCard(light)
        self.init(unnamed: light, dark: dark)
    }

    private init(unnamed light: RGBColor, dark: RGBColor) {
        self.init("Eigene Farbe", light: light.hex, dark: dark.hex)
    }

    private static func liftedForDarkCard(_ color: RGBColor) -> RGBColor {
        let card = EarthPalette.cardSurface.dark
        var lifted = color
        while ColorMath.contrastRatio(lifted, card) < minimumContrastOnDarkCard, lifted.relativeLuminance < 1 {
            lifted = lifted.mixedWithWhite(lighteningStep)
        }
        return lifted
    }
}

extension RGBColor {
    /// Six upper-case hex digits without a number sign.
    public var hex: String {
        String(format: "%02X%02X%02X", Self.byte(red), Self.byte(green), Self.byte(blue))
    }

    private static func byte(_ component: Double) -> Int {
        Int((min(max(component, 0), 1) * 255).rounded())
    }

    fileprivate func mixedWithWhite(_ share: Double) -> RGBColor {
        RGBColor(red: red + (1 - red) * share, green: green + (1 - green) * share, blue: blue + (1 - blue) * share)
    }
}
