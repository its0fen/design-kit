import AppKit
import SwiftUI
import Testing

import DesignKitCore
import DesignKitUI

@Suite("Color bridge")
struct ColorBridgeTests {
    private func rendered(_ color: Color, as name: NSAppearance.Name) -> DesignKitCore.RGBColor? {
        var result: DesignKitCore.RGBColor?
        NSAppearance(named: name)?.performAsCurrentDrawingAppearance {
            guard let srgb = NSColor(color).usingColorSpace(.sRGB) else { return }
            result = DesignKitCore.RGBColor(red: srgb.redComponent, green: srgb.greenComponent, blue: srgb.blueComponent)
        }
        return result
    }

    private func isClose(_ first: DesignKitCore.RGBColor?, _ second: DesignKitCore.RGBColor) -> Bool {
        guard let first else { return false }
        return abs(first.red - second.red) < 1e-3 && abs(first.green - second.green) < 1e-3
            && abs(first.blue - second.blue) < 1e-3
    }

    @Test(arguments: EarthPalette.tagColors + [EarthPalette.cardSurface])
    func aColorShowsItsLightValueInTheLightAppearance(_ color: AdaptiveColor) {
        #expect(isClose(rendered(color.color, as: .aqua), color.light))
    }

    @Test(arguments: EarthPalette.tagColors + [EarthPalette.cardSurface])
    func aColorShowsItsDarkValueInTheDarkAppearance(_ color: AdaptiveColor) {
        #expect(isClose(rendered(color.color, as: .darkAqua), color.dark))
    }

    @Test(arguments: StatusTone.allCases)
    func aStatusToneUsesItsPaletteColor(_ tone: StatusTone) {
        let expected = EarthPalette.status(tone)
        #expect(isClose(rendered(tone.color, as: .aqua), expected.light))
        #expect(isClose(rendered(tone.color, as: .darkAqua), expected.dark))
    }
}
