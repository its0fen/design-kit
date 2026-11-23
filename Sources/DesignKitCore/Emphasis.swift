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
    public static let selection = Emphasis("selection", base: .accent, opacity: 0.2)
    /// A row pointed at from elsewhere, weaker than a selection so both can be told apart.
    public static let highlight = Emphasis("highlight", base: .accent, opacity: 0.1)
    /// The column under the pointer in a chart.
    public static let hoverBand = Emphasis("hover band", base: .primary, opacity: 0.06)
    public static let gridLine = Emphasis("grid line", base: .primary, opacity: 0.1)
    /// A chip that stands for an active choice.
    public static let accentChip = Emphasis("accent chip", base: .accent, opacity: 0.15)
    /// A chip that only labels.
    public static let neutralChip = Emphasis("neutral chip", base: .secondary, opacity: 0.2)
    /// A border or a leader line without a fill.
    public static let outline = Emphasis("outline", base: .secondary, opacity: 0.5)
    /// An inset surface or a placeholder.
    public static let subtleFill = Emphasis("subtle fill", base: .secondary, opacity: 0.1)
    public static let rowSeparator = Emphasis("row separator", base: .separator, opacity: 0.5)
    public static let popoverBorder = Emphasis("popover border", base: .primary, opacity: 0.1)
    public static let popoverShadow = Emphasis("popover shadow", base: .shadow, opacity: 0.15)
    /// The shadow of a toast, which floats over any content.
    public static let toastShadow = Emphasis("toast shadow", base: .shadow, opacity: 0.33)

    public static let all = [
        selection, highlight, hoverBand, gridLine, accentChip, neutralChip, outline, subtleFill, rowSeparator,
        popoverBorder, popoverShadow, toastShadow,
    ]

    /// The strength of a status tone as a background, behind text in that same tone.
    public static let toneFillOpacity = 0.12
    /// The strength of a chart segment that steps back while another one is chosen, applied to the segment's own color.
    public static let dimmedOpacity = 0.3
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
    public static let shadow = FloatingShadow.popover
    public static let shadowRadius = FloatingShadow.popover.radius
    public static let shadowOffsetY = FloatingShadow.popover.offsetY
    public static let borderWidth = LineWidth.regular
}
