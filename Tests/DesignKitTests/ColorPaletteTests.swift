import Foundation
import Testing

import DesignKitCore

/// A fill that is told from the card at all; the palettes other than Earth are chosen for their look.
private let minimumVisibleContrast = 1.3

@Suite("Color palettes")
struct ColorPaletteTests {
    @Test func theFourPalettesAreOfferedWithEarthFirst() {
        #expect(ColorPalette.all.map(\.id) == ["earth", "pastel", "neon", "grayscale"])
    }

    @Test func noLightVariantIsSharedSoAStoredColorNamesItsPair() {
        let lights = ColorPalette.all.flatMap(\.colors).map(\.light.hex)
        #expect(Set(lights).count == lights.count)
    }

    @Test(arguments: ColorPalette.all, PaletteAppearance.allCases)
    func everyColorCanBeSeenOnACard(palette: ColorPalette, appearance: PaletteAppearance) {
        let card = EarthPalette.cardSurface.resolved(for: appearance)
        for color in palette.colors {
            #expect(ColorMath.contrastRatio(color.resolved(for: appearance), card) >= minimumVisibleContrast, "\(color.name)")
        }
    }

    @Test func aStoredLightHexFindsItsPair() {
        #expect(ColorPalette.color(lightHex: "#FF2E93") == ColorPalette.neon.colors[0])
    }

    @Test func aHexNoPaletteHoldsFindsNothing() {
        #expect(ColorPalette.color(lightHex: "123456") == nil)
    }

    @Test func aPickedColorIsUsedAsItIsInLightMode() throws {
        #expect(try #require(AdaptiveColor(pickedHex: "#123456")).light.hex == "123456")
    }

    @Test func aPickedDarkColorIsLiftedUntilItStandsOutOnTheDarkCard() throws {
        let color = try #require(AdaptiveColor(pickedHex: "#101010"))
        #expect(ColorMath.contrastRatio(color.dark, EarthPalette.cardSurface.dark) >= 3)
    }

    @Test func aPickedLightColorStaysAsItIsInDarkMode() throws {
        let color = try #require(AdaptiveColor(pickedHex: "#F5E600"))
        #expect(color.dark == color.light)
    }

    @Test func anInvalidHexIsNoPickedColor() {
        #expect(AdaptiveColor(pickedHex: "rot") == nil)
    }

    @Test(arguments: ["000000", "FFFFFF", "A0790B"])
    func hexRoundTrips(hex: String) throws {
        #expect(try #require(RGBColor(hex: hex)).hex == hex)
    }
}

extension ColorPalette: CustomTestStringConvertible {
    public var testDescription: String { id }
}
