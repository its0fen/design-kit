# DesignKit

Colors and appearance for SwiftUI apps on macOS 14+, with no knowledge of any application.

- `DesignKitCore` (Foundation only, testable): color math (WCAG contrast, OKLab distance, red-green deficiency
  simulation) with the thresholds every palette is held to (`ColorThresholds`), light/dark color pairs, the palettes
  (`EarthPalette` with its tag colors, two series colors and a one-hue ramp for ranked steps; `ColorPalette`), the
  emphasis tokens (`Emphasis`: selection, highlight, chips, grid lines, outlines, separators, the floating card; one
  meaning, one value), the corner radii and the app's appearance choice (system, light, dark).
- `DesignKitUI` (SwiftUI and AppKit): the bridge from a light/dark pair or an emphasis to a `Color`, a status tone's
  background (`StatusTone.fill`), the floating card (`popoverCard()`), and applying the appearance choice to the
  running app.

## Use

```swift
.package(url: "https://github.com/its0fen/design-kit.git", exact: "0.6.0")
```

Add `DesignKitCore` and/or `DesignKitUI` to the target's dependencies.

## Test

```bash
swift run --build-system native DesignKitTests
```

Not `swift test`: with Command Line Tools only (no Xcode) it loads nothing and still exits 0, a false green. The
tests are an ordinary executable that calls swift-testing directly. The default build system cannot load the
swift-testing macro plugin from the Command Line Tools, hence `--build-system native`; with full Xcode the flag is
unnecessary.

## Rules

- The package never imports an application module and names no domain word; `PackageSourceTests` enforces it.
- An app names no hex value, opacity or corner radius of its own: a color or strength it needs is added here first.
- No SwiftUI macros (`@State`, `#Preview`, `@Entry`): they need Xcode.
