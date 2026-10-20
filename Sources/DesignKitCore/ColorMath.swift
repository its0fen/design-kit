import Foundation

/// An sRGB color with components in 0...1, the unit every palette check is computed in.
public struct RGBColor: Sendable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double

    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    /// `"A0790B"` or `"#A0790B"`; nil for anything that is not six hex digits.
    public init?(hex: String) {
        let digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard digits.count == 6, let value = UInt32(digits, radix: 16) else { return nil }
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }

    /// WCAG 2.x relative luminance.
    public var relativeLuminance: Double {
        let linear = linearComponents
        return 0.2126 * linear.red + 0.7152 * linear.green + 0.0722 * linear.blue
    }

    /// Björn Ottosson's OKLab, where Euclidean distance tracks perceived difference far better than in sRGB.
    public var oklab: OKLab {
        let linear = linearComponents
        let long = cbrt(0.4122214708 * linear.red + 0.5363325363 * linear.green + 0.0514459929 * linear.blue)
        let medium = cbrt(0.2119034982 * linear.red + 0.6806995451 * linear.green + 0.1073969566 * linear.blue)
        let short = cbrt(0.0883024619 * linear.red + 0.2817188376 * linear.green + 0.6299787005 * linear.blue)
        return OKLab(
            lightness: 0.2104542553 * long + 0.7936177850 * medium - 0.0040720468 * short,
            greenRed: 1.9779984951 * long - 2.4285922050 * medium + 0.4505937099 * short,
            blueYellow: 0.0259040371 * long + 0.7827717662 * medium - 0.8086757660 * short
        )
    }

    /// How this color looks with the given dichromacy (Machado, Oliveira & Fernandes 2009, severity 1.0).
    public func simulated(_ deficiency: ColorVisionDeficiency) -> RGBColor {
        let linear = linearComponents
        let matrix = deficiency.matrix
        func row(_ index: Int) -> Double {
            let value = matrix[index][0] * linear.red + matrix[index][1] * linear.green + matrix[index][2] * linear.blue
            return Self.encoded(min(max(value, 0), 1))
        }
        return RGBColor(red: row(0), green: row(1), blue: row(2))
    }

    private var linearComponents: (red: Double, green: Double, blue: Double) {
        (Self.linearized(red), Self.linearized(green), Self.linearized(blue))
    }

    private static func linearized(_ component: Double) -> Double {
        component <= 0.04045 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
    }

    private static func encoded(_ linear: Double) -> Double {
        linear <= 0.0031308 ? 12.92 * linear : 1.055 * pow(linear, 1 / 2.4) - 0.055
    }

}

public struct OKLab: Sendable, Equatable {
    public let lightness: Double
    public let greenRed: Double
    public let blueYellow: Double
}

public enum ColorVisionDeficiency: Sendable, CaseIterable {
    case protanopia, deuteranopia

    fileprivate var matrix: [[Double]] {
        switch self {
        case .protanopia:
            [[0.152286, 1.052583, -0.204868], [0.114503, 0.786281, 0.099216], [-0.003882, -0.048116, 1.051998]]
        case .deuteranopia:
            [[0.367322, 0.860646, -0.227968], [0.280085, 0.672501, 0.047413], [-0.011820, 0.042940, 0.968881]]
        }
    }
}

public enum ColorMath {
    /// WCAG 2.x contrast ratio, 1...21, symmetric in its arguments.
    public static func contrastRatio(_ first: RGBColor, _ second: RGBColor) -> Double {
        let lighter = max(first.relativeLuminance, second.relativeLuminance)
        let darker = min(first.relativeLuminance, second.relativeLuminance)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// ΔE in OKLab: about 0.02 is a just-noticeable difference.
    public static func perceptualDistance(_ first: RGBColor, _ second: RGBColor) -> Double {
        let (a, b) = (first.oklab, second.oklab)
        let lightness = a.lightness - b.lightness
        let greenRed = a.greenRed - b.greenRed
        let blueYellow = a.blueYellow - b.blueYellow
        return (lightness * lightness + greenRed * greenRed + blueYellow * blueYellow).squareRoot()
    }

    /// The smallest distance between any two colors, after simulating `deficiency` when given; infinity for fewer than two.
    public static func smallestDistance(among colors: [RGBColor], seenWith deficiency: ColorVisionDeficiency? = nil) -> Double {
        closestPairs(among: colors, seenWith: deficiency, count: 1).first?.distance ?? .infinity
    }

    /// The `count` closest pairs by index, nearest first.
    public static func closestPairs(
        among colors: [RGBColor], seenWith deficiency: ColorVisionDeficiency? = nil, count: Int
    ) -> [(first: Int, second: Int, distance: Double)] {
        let seen = deficiency.map { deficiency in colors.map { $0.simulated(deficiency) } } ?? colors
        var pairs: [(first: Int, second: Int, distance: Double)] = []
        for first in seen.indices {
            for second in seen.indices where second > first {
                pairs.append((first, second, perceptualDistance(seen[first], seen[second])))
            }
        }
        return Array(pairs.sorted { $0.distance < $1.distance }.prefix(count))
    }
}
