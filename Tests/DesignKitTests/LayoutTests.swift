import AppKit
import SwiftUI
import Testing

import DesignKitCore
import DesignKitUI

@Suite("Layout tokens")
struct LayoutTokenTests {
    private static func isStrictlyIncreasing(_ values: [Double]) -> Bool {
        zip(values, values.dropFirst()).allSatisfy { $0 < $1 }
    }

    @Test func theSpacingScaleGrowsWithEveryStep() {
        #expect(Self.isStrictlyIncreasing(Spacing.scale))
    }

    @Test func theSpacingScaleRunsFromTheTightestGapToAPagesMargin() {
        #expect(Spacing.scale.first == Spacing.xxxs)
        #expect(Spacing.scale.last == Spacing.xxxl)
        #expect(Spacing.scale.allSatisfy { $0 > 0 })
    }

    @Test func theLineWidthsGrowWithEveryStep() {
        #expect(Self.isStrictlyIncreasing(LineWidth.scale))
        #expect(LineWidth.scale.allSatisfy { $0 > 0 })
    }

    @Test func aBorderIsOneOfTheLineWidths() {
        #expect(LineWidth.scale.contains(PopoverCardStyle.borderWidth))
        #expect(LineWidth.scale.contains(CardSurfaceStyle.borderWidth))
    }

    @Test func aCardSurfaceTakesOneOfTheCornerRadii() {
        #expect([CornerRadius.small, CornerRadius.large].contains(CardSurfaceStyle.cornerRadius))
    }
}

@Suite("Floating shadows")
struct FloatingShadowTests {
    @Test func thePopoverCardKeepsItsShadow() {
        #expect(PopoverCardStyle.shadow == .popover)
        #expect(PopoverCardStyle.shadowRadius == FloatingShadow.popover.radius)
        #expect(PopoverCardStyle.shadowOffsetY == FloatingShadow.popover.offsetY)
    }

    @Test func everyShadowFallsBelowWhatItCarries() {
        for style in [FloatingShadow.popover, .toast] {
            #expect(style.radius > 0)
            #expect(style.offsetY > 0)
            #expect(style.emphasis.base == .shadow)
        }
    }

    /// A toast floats over any content, a popover only over a chart's quiet card, so the toast's shadow is darker.
    @Test func aToastCastsADarkerButTighterShadowThanAPopover() {
        #expect(FloatingShadow.toast.emphasis.opacity > FloatingShadow.popover.emphasis.opacity)
        #expect(FloatingShadow.toast.radius < FloatingShadow.popover.radius)
    }

    @Test func everyShadowUsesAnEmphasisOfThePackage() {
        #expect(Emphasis.all.contains(FloatingShadow.popover.emphasis))
        #expect(Emphasis.all.contains(FloatingShadow.toast.emphasis))
    }
}

@Suite("Card surface")
@MainActor
struct CardSurfaceTests {
    private static let size = 40

    private func centerPixel(of view: some View, as name: NSAppearance.Name) -> NSColor? {
        var color: NSColor?
        NSAppearance(named: name)?.performAsCurrentDrawingAppearance {
            let scheme: ColorScheme = name == .darkAqua ? .dark : .light
            let sized = view.frame(width: CGFloat(Self.size), height: CGFloat(Self.size)).environment(\.colorScheme, scheme)
            let renderer = ImageRenderer(content: sized)
            renderer.scale = 1
            guard let image = renderer.cgImage else { return }
            color = NSBitmapImageRep(cgImage: image).colorAt(x: Self.size / 2, y: Self.size / 2)?.usingColorSpace(.sRGB)
        }
        return color
    }

    @Test func aCardSurfaceFillsWithTheTextBackground() throws {
        let rendered = try #require(centerPixel(of: Color.clear.cardSurface(), as: .aqua))
        var resolved: NSColor?
        NSAppearance(named: .aqua)?.performAsCurrentDrawingAppearance {
            resolved = NSColor.textBackgroundColor.usingColorSpace(.sRGB)
        }
        let expected = try #require(resolved)
        #expect(abs(rendered.redComponent - expected.redComponent) < 0.02)
        #expect(abs(rendered.greenComponent - expected.greenComponent) < 0.02)
        #expect(abs(rendered.blueComponent - expected.blueComponent) < 0.02)
        #expect(rendered.alphaComponent > 0.98)
    }

    @Test func aBorderedCardSurfaceKeepsTheFillInside() throws {
        let rendered = try #require(centerPixel(of: Color.clear.cardSurface(bordered: true), as: .aqua))
        #expect(rendered.alphaComponent > 0.98)
    }
}
