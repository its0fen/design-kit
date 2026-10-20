import Foundation
import Testing

import DesignKitCore

private let white = RGBColor(red: 1, green: 1, blue: 1)
private let black = RGBColor(red: 0, green: 0, blue: 0)

@Suite("Color math")
struct ColorMathTests {
    @Test func parsesSixHexDigitsWithOrWithoutAHash() {
        #expect(RGBColor(hex: "#FF8000") == RGBColor(red: 1, green: 128.0 / 255, blue: 0))
        #expect(RGBColor(hex: "ff8000") == RGBColor(red: 1, green: 128.0 / 255, blue: 0))
    }

    @Test(arguments: ["FFFFF", "FFFFFFF", "GGGGGG", "", "#"])
    func rejectsAnythingButSixHexDigits(_ hex: String) {
        #expect(RGBColor(hex: hex) == nil)
    }

    @Test func blackOnWhiteIsTheMaximumContrastOfTwentyOne() {
        #expect(abs(ColorMath.contrastRatio(black, white) - 21) < 1e-9)
    }

    @Test func aColorAgainstItselfHasContrastOne() {
        let gray = RGBColor(hex: "808080")!
        #expect(abs(ColorMath.contrastRatio(gray, gray) - 1) < 1e-9)
    }

    @Test func contrastIsSymmetric() {
        let first = RGBColor(hex: "246776")!
        #expect(ColorMath.contrastRatio(first, white) == ColorMath.contrastRatio(white, first))
    }

    @Test func midGrayHasTheReferenceRelativeLuminance() {
        #expect(abs(RGBColor(hex: "808080")!.relativeLuminance - 0.2158605) < 1e-6)
    }

    @Test func whiteIsLightnessOneWithoutHueInOKLab() {
        let lab = white.oklab
        #expect(abs(lab.lightness - 1) < 1e-4)
        #expect(abs(lab.greenRed) < 1e-4)
        #expect(abs(lab.blueYellow) < 1e-4)
    }

    @Test func pureRedMatchesOttossonsReferenceValues() {
        let lab = RGBColor(red: 1, green: 0, blue: 0).oklab
        #expect(abs(lab.lightness - 0.62796) < 1e-4)
        #expect(abs(lab.greenRed - 0.22486) < 1e-4)
        #expect(abs(lab.blueYellow - 0.12585) < 1e-4)
    }

    @Test func identicalColorsHaveDistanceZero() {
        #expect(ColorMath.perceptualDistance(white, white) == 0)
    }

    @Test func blackAndWhiteAreDistanceOneApart() {
        #expect(abs(ColorMath.perceptualDistance(black, white) - 1) < 1e-4)
    }

    @Test(arguments: ColorVisionDeficiency.allCases)
    func aDeficiencyLeavesGraysGray(_ deficiency: ColorVisionDeficiency) {
        let gray = RGBColor(hex: "777777")!
        #expect(ColorMath.perceptualDistance(gray.simulated(deficiency), gray) < 0.01)
    }

    @Test(arguments: ColorVisionDeficiency.allCases)
    func aDeficiencyBringsRedAndGreenOfEqualLightnessCloserTogether(_ deficiency: ColorVisionDeficiency) {
        let red = RGBColor(hex: "B5574F")!
        let green = RGBColor(hex: "4F8F57")!
        let normal = ColorMath.perceptualDistance(red, green)
        let simulated = ColorMath.perceptualDistance(red.simulated(deficiency), green.simulated(deficiency))
        #expect(simulated < normal)
    }

    @Test func protanopiaMapsPureRedToMachadosDarkOlive() {
        let simulated = RGBColor(red: 1, green: 0, blue: 0).simulated(.protanopia)
        #expect(abs(simulated.red - 0.4266) < 1e-3)
        #expect(abs(simulated.green - 0.3727) < 1e-3)
        #expect(simulated.blue == 0)
    }

    @Test func smallestDistanceOfFewerThanTwoColorsIsInfinite() {
        #expect(ColorMath.smallestDistance(among: []) == .infinity)
        #expect(ColorMath.smallestDistance(among: [white]) == .infinity)
    }

    @Test func closestPairsComeNearestFirst() {
        let colors = [black, white, RGBColor(hex: "FAFAFA")!]
        let pairs = ColorMath.closestPairs(among: colors, count: 2)
        #expect(pairs.map { [$0.first, $0.second] } == [[1, 2], [0, 2]])
    }
}
