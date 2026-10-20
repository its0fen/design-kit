import AppKit
import Foundation
import Testing

import DesignKitCore
import DesignKitUI

private func isolatedDefaults() throws -> (UserDefaults, () -> Void) {
    let suite = "designkit-appearance-\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suite))
    return (defaults, { defaults.removePersistentDomain(forName: suite) })
}

@Suite("Appearance choice")
struct AppearanceChoiceTests {
    @Test func theAppFollowsTheSystemUntilTheUserChooses() throws {
        let (defaults, cleanup) = try isolatedDefaults()
        defer { cleanup() }

        #expect(AppearanceChoice.stored(in: defaults) == .system)
        #expect(AppearanceChoice.system.forcedPalette == nil)
    }

    @Test(arguments: AppearanceChoice.allCases)
    func aChoiceIsStoredAndReadBack(choice: AppearanceChoice) throws {
        let (defaults, cleanup) = try isolatedDefaults()
        defer { cleanup() }

        choice.store(in: defaults)

        #expect(AppearanceChoice.stored(in: defaults) == choice)
    }

    @Test func aStoredValueNobodyDefinedCountsAsSystem() throws {
        let (defaults, cleanup) = try isolatedDefaults()
        defer { cleanup() }
        defaults.set("sepia", forKey: AppearanceChoice.defaultsKey)

        #expect(AppearanceChoice.stored(in: defaults) == .system)
    }

    @Test func theChoicesAreNamedAndForceTheirPalette() {
        #expect(AppearanceChoice.allCases.map(\.title) == ["System", "Hell", "Dunkel"])
        #expect(AppearanceChoice.allCases.map(\.forcedPalette) == [nil, .light, .dark])
    }
}

@Suite("Appearance application")
@MainActor
struct AppearanceApplicationTests {
    @Test(arguments: AppearanceChoice.allCases)
    func applyingAChoiceSetsTheApplicationAppearance(choice: AppearanceChoice) {
        let before = NSApplication.shared.appearance
        defer { NSApplication.shared.appearance = before }

        choice.apply()

        let expected: NSAppearance.Name? = switch choice {
        case .system: nil
        case .light: .aqua
        case .dark: .darkAqua
        }
        #expect(NSApplication.shared.appearance?.name == expected)
    }
}
