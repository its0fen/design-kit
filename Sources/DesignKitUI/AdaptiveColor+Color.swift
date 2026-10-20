import AppKit
import DesignKitCore
import SwiftUI

extension AdaptiveColor {
    /// Follows the view's appearance, so light and dark need no branch in any view.
    public var color: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
            let rgb = resolved(for: isDark ? .dark : .light)
            return NSColor(srgbRed: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1)
        })
    }
}

extension StatusTone {
    public var color: Color { EarthPalette.status(self).color }
}
