import Foundation
import Testing

import DesignKitCore

/// WCAG 1.4.11 for graphical objects; 1.4.3 for normal text.
private let minimumNonTextContrast = 3.0
private let minimumTextContrast = 4.5
/// ΔE_OK 0.02 is about one just-noticeable difference; 0.08 keeps two small dots or thin bars apart at a glance.
private let minimumTagDistance = 0.08
/// Dichromats lose a whole axis of OKLab, so 15 colors cannot keep 0.08 there; 0.05 is still clearly more than two
/// noticeable steps apart.
private let minimumTagDistanceWithDeficiency = 0.05

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
            #expect(ColorMath.contrastRatio(color.resolved(for: appearance), card) >= minimumNonTextContrast, "\(color.name)")
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
            #expect(ratio >= minimumNonTextContrast, "\(color.name)")
        }
    }

    @Test(arguments: PaletteAppearance.allCases)
    func everyTwoTagColorsAreApartWithNormalVision(_ appearance: PaletteAppearance) {
        let colors = EarthPalette.tagColors.map { $0.resolved(for: appearance) }
        #expect(ColorMath.smallestDistance(among: colors) >= minimumTagDistance)
    }

    @Test(arguments: PaletteAppearance.allCases, ColorVisionDeficiency.allCases)
    func everyTwoTagColorsStayApartWithRedGreenDeficiency(_ appearance: PaletteAppearance, _ deficiency: ColorVisionDeficiency) {
        let colors = EarthPalette.tagColors.map { $0.resolved(for: appearance) }
        #expect(ColorMath.smallestDistance(among: colors, seenWith: deficiency) >= minimumTagDistanceWithDeficiency)
    }

    @Test(arguments: PaletteAppearance.allCases, StatusTone.allCases)
    func statusColorsAreReadableAsTextOnCardAndPage(_ appearance: PaletteAppearance, _ tone: StatusTone) {
        let text = EarthPalette.status(tone).resolved(for: appearance)
        for surface in [EarthPalette.cardSurface, EarthPalette.pageBackground] {
            #expect(ColorMath.contrastRatio(text, surface.resolved(for: appearance)) >= minimumTextContrast)
        }
    }

    @Test(arguments: PaletteAppearance.allCases)
    func positiveAndNegativeStayApartWithRedGreenDeficiency(_ appearance: PaletteAppearance) {
        let colors = [StatusTone.positive, .negative].map { EarthPalette.status($0).resolved(for: appearance) }
        for deficiency in ColorVisionDeficiency.allCases {
            #expect(ColorMath.smallestDistance(among: colors, seenWith: deficiency) >= minimumTagDistanceWithDeficiency)
        }
    }
}
