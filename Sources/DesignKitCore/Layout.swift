import Foundation

/// Space between and around views, as one scale: a stack's `spacing` and a `padding` take one of these, never a
/// number of their own. Each step is larger than the one before, so a view can step up or down without looking up
/// values.
public enum Spacing {
    /// Between a label and its own detail, such as a title and its subtitle.
    public static let xxxs = 2.0
    public static let xxs = 3.0
    /// Inside a chip or a compact row.
    public static let xs = 4.0
    /// Inside a row; between closely related controls.
    public static let s = 6.0
    /// The default between items of one group.
    public static let m = 8.0
    public static let l = 10.0
    /// Between groups inside one card.
    public static let xl = 12.0
    public static let xxl = 16.0
    /// Around a sheet's or a page's content.
    public static let xxxl = 20.0

    /// Every step, smallest first.
    public static let scale = [xxxs, xxs, xs, s, m, l, xl, xxl, xxxl]
}

/// Stroke widths for lines that draw rather than fill: a grid line, an outline, a border, a separator in a chart.
public enum LineWidth {
    /// Grid lines, the faintest structure.
    public static let hairline = 0.5
    /// Outlines and leader lines around chart segments.
    public static let thin = 0.75
    /// Borders of cards and controls.
    public static let regular = 1.0
    /// A gap cut between neighbouring segments, or a mark that has to stand out.
    public static let bold = 1.5

    /// Every width, thinnest first.
    public static let scale = [hairline, thin, regular, bold]
}

/// A shadow under something floating above the content; the view layer resolves `emphasis` to its color.
public struct FloatingShadow: Sendable, Equatable {
    public let emphasis: Emphasis
    public let radius: Double
    public let offsetY: Double

    public init(emphasis: Emphasis, radius: Double, offsetY: Double) {
        self.emphasis = emphasis
        self.radius = radius
        self.offsetY = offsetY
    }

    /// A small card floating over a chart.
    public static let popover = FloatingShadow(emphasis: .popoverShadow, radius: 6, offsetY: 2)
    /// A short confirmation floating at the bottom of a window: smaller than a card, but darker, since it sits on any
    /// content rather than on a chart's quiet surface.
    public static let toast = FloatingShadow(emphasis: .toastShadow, radius: 4, offsetY: 1)
}

/// A surface in the text background color that sets content apart from the window, optionally with a border.
public enum CardSurfaceStyle {
    public static let cornerRadius = CornerRadius.large
    public static let borderWidth = LineWidth.regular
}
