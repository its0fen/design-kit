import Foundation
import Testing

import DesignKitCore

@Suite("Sequential ramp")
struct SequentialRampTests {
    @Test func theRampFollowsTheRankWithAStrongerColorForAHigherOne() {
        let colors = [0.25, 0.5, 0.75, 1.0].map { EarthPalette.sequentialColor(intensity: $0) }

        #expect(colors == EarthPalette.sequentialRamp)
    }

    @Test(arguments: PaletteAppearance.allCases)
    func theRampStrengthensMonotonicallyInBothAppearances(_ appearance: PaletteAppearance) {
        let lightness = EarthPalette.sequentialRamp.map { $0.resolved(for: appearance).oklab.lightness }
        let steps = zip(lightness, lightness.dropFirst()).map { $1 - $0 }

        if appearance == .light {
            #expect(steps.allSatisfy { $0 < 0 })
        } else {
            #expect(steps.allSatisfy { $0 > 0 })
        }
    }

    @Test(arguments: PaletteAppearance.allCases)
    func everyStepStandsOutAgainstCardAndPage(_ appearance: PaletteAppearance) {
        for surface in [EarthPalette.cardSurface, EarthPalette.pageBackground] {
            for color in EarthPalette.sequentialRamp {
                let ratio = ColorMath.contrastRatio(color.resolved(for: appearance), surface.resolved(for: appearance))
                #expect(ratio >= ColorThresholds.nonTextContrast, "\(color.name)")
            }
        }
    }

    @Test(arguments: PaletteAppearance.allCases, [nil] + ColorVisionDeficiency.allCases.map(Optional.some))
    func neighbouringStepsAreApartWithNormalVisionAndRedGreenDeficiency(
        _ appearance: PaletteAppearance, _ deficiency: ColorVisionDeficiency?
    ) {
        let colors = EarthPalette.sequentialRamp.map { $0.resolved(for: appearance) }
        for (first, second) in zip(colors, colors.dropFirst()) {
            let distance = deficiency.map { ColorMath.perceptualDistance(first.simulated($0), second.simulated($0)) }
                ?? ColorMath.perceptualDistance(first, second)
            #expect(distance >= ColorThresholds.distinctColors)
        }
    }

    @Test func anIntensityOutsideTheRangeStaysOnTheEnds() {
        #expect(EarthPalette.sequentialColor(intensity: 0) == EarthPalette.sequentialRamp[0])
        #expect(EarthPalette.sequentialColor(intensity: 2) == EarthPalette.sequentialRamp[3])
    }
}

@Suite("Series colors")
struct SeriesColorsTests {
    @Test func theSeriesAreTagColorsSoNoHexIsDefinedTwice() {
        #expect(EarthPalette.seriesColors.allSatisfy(EarthPalette.tagColors.contains))
    }

    @Test(arguments: PaletteAppearance.allCases)
    func everySeriesStandsOutOnCardAndPage(_ appearance: PaletteAppearance) {
        for surface in [EarthPalette.cardSurface, EarthPalette.pageBackground] {
            for color in EarthPalette.seriesColors {
                let ratio = ColorMath.contrastRatio(color.resolved(for: appearance), surface.resolved(for: appearance))
                #expect(ratio >= ColorThresholds.nonTextContrast, "\(color.name)")
            }
        }
    }

    @Test(arguments: PaletteAppearance.allCases, [nil] + ColorVisionDeficiency.allCases.map(Optional.some))
    func theSeriesStayApartWithNormalVisionAndRedGreenDeficiency(
        _ appearance: PaletteAppearance, _ deficiency: ColorVisionDeficiency?
    ) {
        let series = EarthPalette.seriesColors.map { $0.resolved(for: appearance) }
        #expect(ColorMath.smallestDistance(among: series, seenWith: deficiency) >= ColorThresholds.distinctColors)
    }
}

@Suite("Emphasis")
struct EmphasisTests {
    /// Black or white text color, the base `primary` resolves to.
    private static func primary(_ appearance: PaletteAppearance) -> RGBColor {
        appearance == .light ? RGBColor(red: 0, green: 0, blue: 0) : RGBColor(red: 1, green: 1, blue: 1)
    }

    private static func blended(_ color: RGBColor, over surface: RGBColor, opacity: Double) -> RGBColor {
        RGBColor(
            red: color.red * opacity + surface.red * (1 - opacity),
            green: color.green * opacity + surface.green * (1 - opacity),
            blue: color.blue * opacity + surface.blue * (1 - opacity)
        )
    }

    @Test func everyEmphasisHasItsOwnName() {
        #expect(Set(Emphasis.all.map(\.name)).count == Emphasis.all.count)
    }

    @Test func everyEmphasisIsTranslucent() {
        #expect((Emphasis.all.map(\.opacity) + [Emphasis.toneFillOpacity]).allSatisfy { $0 > 0 && $0 < 1 })
    }

    @Test func aSelectionIsStrongerThanAHighlightOnTheSameBase() {
        #expect(Emphasis.selection.base == Emphasis.highlight.base)
        #expect(Emphasis.selection.opacity > Emphasis.highlight.opacity)
    }

    /// The weakest marks on `primary` still change the surface enough to be seen; 1.1 is just above what a hover band
    /// needs over a white page.
    @Test(arguments: PaletteAppearance.allCases)
    func theMarksOnPrimaryCanBeSeenOnCardAndPage(_ appearance: PaletteAppearance) {
        let marks = Emphasis.all.filter { $0.base == .primary }
        for surface in [EarthPalette.cardSurface, EarthPalette.pageBackground].map({ $0.resolved(for: appearance) }) {
            for mark in marks {
                let shown = Self.blended(Self.primary(appearance), over: surface, opacity: mark.opacity)
                #expect(ColorMath.contrastRatio(shown, surface) >= 1.1, "\(mark.name)")
            }
        }
    }

    @Test func aCornerRadiusIsOneOfTwo() {
        #expect(CornerRadius.small < CornerRadius.large)
        #expect(PopoverCardStyle.cornerRadius == CornerRadius.small)
    }
}
