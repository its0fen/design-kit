import AppKit
import DesignKitCore
import SwiftUI

extension EmphasisBase {
    public var color: Color {
        switch self {
        case .accent: Color.accentColor
        case .primary: Color.primary
        case .secondary: Color.secondary
        case .separator: Color(nsColor: .separatorColor)
        case .shadow: Color(nsColor: .shadowColor)
        }
    }
}

extension Emphasis {
    public var color: Color { base.color.opacity(opacity) }
}

extension StatusTone {
    /// The tone as a background, for a banner whose text is in the tone itself.
    public var fill: Color { color.opacity(Emphasis.toneFillOpacity) }
}

extension View {
    /// A shadow in one of the package's styles.
    public func floatingShadow(_ style: FloatingShadow) -> some View {
        shadow(color: style.emphasis.color, radius: style.radius, y: style.offsetY)
    }

    /// A small card floating over a chart: material, border and shadow as every such card has them.
    public func popoverCard() -> some View {
        let shape = RoundedRectangle(cornerRadius: PopoverCardStyle.cornerRadius)
        return background(shape.fill(.regularMaterial))
            .floatingShadow(PopoverCardStyle.shadow)
            .overlay(shape.stroke(Emphasis.popoverBorder.color, lineWidth: PopoverCardStyle.borderWidth))
    }

    /// A short confirmation floating over the content: material in a capsule with the toast's shadow.
    public func toastSurface() -> some View {
        background(.regularMaterial, in: Capsule()).floatingShadow(.toast)
    }

    /// A surface in the text background color that sets content apart from the window; `bordered` adds the separator
    /// color as a border inside its edge.
    public func cardSurface(bordered: Bool = false, cornerRadius: Double = CardSurfaceStyle.cornerRadius) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        return background(shape.fill(CardSurfaceColor.fill))
            .overlay(shape.strokeBorder(bordered ? CardSurfaceColor.border : Color.clear, lineWidth: CardSurfaceStyle.borderWidth))
    }
}

/// The system colors a card surface is drawn in, so the modifier and its tests name them once.
public enum CardSurfaceColor {
    public static let fill = Color(nsColor: .textBackgroundColor)
    public static let border = Color(nsColor: .separatorColor)
}
