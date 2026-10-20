import Foundation

/// Muted earth tones; neighbours are told apart by lightness as much as by hue,
/// because earth hues alone sit too close together.
public enum EarthPalette {
    /// GroupBox fill as rendered on macOS 14+, the surface every series color and chart sits on.
    public static let cardSurface = AdaptiveColor("Karte", light: "F8F8F8", dark: "2F3131")
    public static let pageBackground = AdaptiveColor("Seite", light: "FFFFFF", dark: "262728")

    /// Interleaved warm/cool, so a short list still spreads across the wheel.
    public static let tagColors: [AdaptiveColor] = [
        AdaptiveColor("Petrol", light: "246776", dark: "73B4C4"),
        AdaptiveColor("Terrakotta", light: "9C5B4A", dark: "F0A895"),
        AdaptiveColor("Oliv", light: "475402", dark: "85964E"),
        AdaptiveColor("Schiefer", light: "6C89AA", dark: "B6D6F9"),
        AdaptiveColor("Ocker", light: "A0790B", dark: "EDC367"),
        AdaptiveColor("Pflaume", light: "693A56", dark: "B7829F"),
        AdaptiveColor("Moos", light: "698C54", dark: "BEE4A8"),
        AdaptiveColor("Ziegel", light: "95352F", dark: "E0796F"),
        AdaptiveColor("Salbei", light: "5F756A", dark: "AAC2B6"),
        AdaptiveColor("Umbra", light: "543010", dark: "9B7353"),
        AdaptiveColor("Indigo", light: "454C76", dark: "737BA9"),
        AdaptiveColor("Senf", light: "746900", dark: "BEB35E"),
        AdaptiveColor("Tanne", light: "1B3C37", dark: "5F817B"),
        AdaptiveColor("Altrosa", light: "AA7B87", dark: "FBC7D3"),
        AdaptiveColor("Taupe", light: "5F554C", dark: "ACA196"),
    ]

    /// For an item beyond the palette or without a color of its own: never another item's color.
    public static let unassignedTag = AdaptiveColor("Ohne Farbe", light: "8A8A8A", dark: "7A7A7A")

    public static func status(_ tone: StatusTone) -> AdaptiveColor {
        switch tone {
        case .positive: AdaptiveColor("Positiv", light: "357A43", dark: "96E4A1")
        case .negative: AdaptiveColor("Negativ", light: "862723", dark: "EB827B")
        case .warning: AdaptiveColor("Warnung", light: "9C5906", dark: "F2B458")
        case .neutral: AdaptiveColor("Neutral", light: "696969", dark: "ABABAB")
        }
    }
}
