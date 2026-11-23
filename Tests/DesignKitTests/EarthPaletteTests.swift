import Foundation
import Testing

import DesignKitCore

@Suite("Earth palette")
struct EarthPaletteTests {
    @Test func holdsFifteenTagColors() {
        #expect(EarthPalette.tagColors.count >= 15)
    }

    @Test func tagColorsAreAllDistinct() {
        #expect(Set(EarthPalette.tagColors.map(\.name)).count == EarthPalette.tagColors.count)
    }

    @Test(arguments: PaletteAppearance.allCases)
    func everyTagColorStandsOutAgainstTheCard(_ appearance: PaletteAppearance) {
        let card = EarthPalette.cardSurface.resolved(for: appearance)
        for color in EarthPalette.tagColors + [EarthPalette.unassignedTag] {
            #expect(ColorMath.contrastRatio(color.resolved(for: appearance), card) >= ColorThresholds.nonTextContrast, "\(color.name)")
        }
    }

    /// The appearance can be forced for every window, so the page counts too, not only the card. Below the threshold a
    /// color is changed in the palette, never exempted here.
    @Test(arguments: PaletteAppearance.allCases)
    func everyDataColorStandsOutAgainstThePageInLightAndDark(_ appearance: PaletteAppearance) {
        let page = EarthPalette.pageBackground.resolved(for: appearance)
        let colors = EarthPalette.tagColors + [EarthPalette.unassignedTag] + StatusTone.allCases.map(EarthPalette.status)
        for color in colors {
            let ratio = ColorMath.contrastRatio(color.resolved(for: appearance), page)
            #expect(ratio >= ColorThresholds.nonTextContrast, "\(color.name)")
        }
    }

    @Test(arguments: PaletteAppearance.allCases)
    func everyTwoTagColorsAreApartWithNormalVision(_ appearance: PaletteAppearance) {
        let colors = EarthPalette.tagColors.map { $0.resolved(for: appearance) }
        #expect(ColorMath.smallestDistance(among: colors) >= ColorThresholds.distinctColors)
    }

    @Test(arguments: PaletteAppearance.allCases, ColorVisionDeficiency.allCases)
    func everyTwoTagColorsStayApartWithRedGreenDeficiency(_ appearance: PaletteAppearance, _ deficiency: ColorVisionDeficiency) {
        let colors = EarthPalette.tagColors.map { $0.resolved(for: appearance) }
        #expect(ColorMath.smallestDistance(among: colors, seenWith: deficiency) >= ColorThresholds.distinctColorsWithDeficiency)
    }

    @Test(arguments: PaletteAppearance.allCases, StatusTone.allCases)
    func statusColorsAreReadableAsTextOnCardAndPage(_ appearance: PaletteAppearance, _ tone: StatusTone) {
        let text = EarthPalette.status(tone).resolved(for: appearance)
        for surface in [EarthPalette.cardSurface, EarthPalette.pageBackground] {
            #expect(ColorMath.contrastRatio(text, surface.resolved(for: appearance)) >= ColorThresholds.textContrast)
        }
    }

    @Test(arguments: PaletteAppearance.allCases)
    func positiveAndNegativeStayApartWithRedGreenDeficiency(_ appearance: PaletteAppearance) {
        let colors = [StatusTone.positive, .negative].map { EarthPalette.status($0).resolved(for: appearance) }
        for deficiency in ColorVisionDeficiency.allCases {
            #expect(ColorMath.smallestDistance(among: colors, seenWith: deficiency) >= ColorThresholds.distinctColorsWithDeficiency)
        }
    }
}
