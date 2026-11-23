import Foundation

/// The limits every palette is held to, here and in an app that adds colors of its own, so no check sets a
/// threshold of its own.
public enum ColorThresholds {
    /// WCAG 1.4.11 for graphical objects.
    public static let nonTextContrast = 3.0
    /// WCAG 1.4.3 for normal text.
    public static let textContrast = 4.5
    /// ΔE_OK 0.02 is about one just-noticeable difference; 0.08 keeps two small dots or thin bars apart at a glance.
    public static let distinctColors = 0.08
    /// Dichromats lose a whole axis of OKLab, so 15 colors cannot keep 0.08 there; 0.05 is still clearly more than two
    /// noticeable steps apart.
    public static let distinctColorsWithDeficiency = 0.05
    /// A fill that is told from the card at all; for palettes chosen for their look.
    public static let visibleContrast = 1.3
}
