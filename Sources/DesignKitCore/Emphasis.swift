import Foundation

/// What a translucent emphasis is laid over: a system color the view layer resolves, never a hue of its own.
public enum EmphasisBase: Sendable, CaseIterable {
    case accent, primary, secondary, separator, shadow
}

/// A system color at a fixed strength, for marking rather than coloring: a selected row, a chip, a grid line. One
/// meaning has one value, so a selection looks the same in every list.
public struct Emphasis: Sendable, Equatable {
    public let name: String
    public let base: EmphasisBase
    public let opacity: Double

    public init(_ name: String, base: EmphasisBase, opacity: Double) {
        self.name = name
        self.base = base
        self.opacity = opacity
    }

    /// The row or item the user selected.
    public static let selection = Emphasis("Auswahl", base: .accent, opacity: 0.2)
    /// A row pointed at from elsewhere, weaker than a selection so both can be told apart.
    public static let highlight = Emphasis("Hervorhebung", base: .accent, opacity: 0.1)
    /// The column under the pointer in a chart.
    public static let hoverBand = Emphasis("Zeigerspalte", base: .primary, opacity: 0.06)
    public static let gridLine = Emphasis("Rasterlinie", base: .primary, opacity: 0.1)
    /// A chip that stands for an active choice.
    public static let accentChip = Emphasis("Chip", base: .accent, opacity: 0.15)
    /// A chip that only labels.
    public static let neutralChip = Emphasis("Etikett", base: .secondary, opacity: 0.2)
    /// A border or a leader line without a fill.
    public static let outline = Emphasis("Umriss", base: .secondary, opacity: 0.5)
    /// An inset surface or a placeholder.
    public static let subtleFill = Emphasis("Fläche", base: .secondary, opacity: 0.1)
    public static let rowSeparator = Emphasis("Trennlinie", base: .separator, opacity: 0.5)
    public static let popoverBorder = Emphasis("Kartenrand", base: .primary, opacity: 0.1)
    public static let popoverShadow = Emphasis("Kartenschatten", base: .shadow, opacity: 0.15)

    public static let all = [
        selection, highlight, hoverBand, gridLine, accentChip, neutralChip, outline, subtleFill, rowSeparator,
        popoverBorder, popoverShadow,
    ]

    /// The strength of a status tone as a background, behind text in that same tone.
    public static let toneFillOpacity = 0.12
}

/// Corner radii; a surface takes one of these, never a number of its own.
public enum CornerRadius {
    /// Rows, insets and floating cards.
    public static let small = 6.0
    /// Banners and larger surfaces.
    public static let large = 8.0
}

/// A small card floating over a chart.
public enum PopoverCardStyle {
    public static let cornerRadius = CornerRadius.small
    public static let shadowRadius = 6.0
    public static let shadowOffsetY = 2.0
    public static let borderWidth = 1.0
}
