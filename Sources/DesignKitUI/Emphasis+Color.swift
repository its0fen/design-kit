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
    /// A small card floating over a chart: material, border and shadow as every such card has them.
    public func popoverCard() -> some View {
        let shape = RoundedRectangle(cornerRadius: PopoverCardStyle.cornerRadius)
        return background(shape.fill(.regularMaterial))
            .shadow(color: Emphasis.popoverShadow.color, radius: PopoverCardStyle.shadowRadius, y: PopoverCardStyle.shadowOffsetY)
            .overlay(shape.stroke(Emphasis.popoverBorder.color, lineWidth: PopoverCardStyle.borderWidth))
    }
}
