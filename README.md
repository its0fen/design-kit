# DesignKit

Colors and appearance for SwiftUI apps on macOS 14+, with no knowledge of any application.

- `DesignKitCore` (Foundation only, testable): color math (WCAG contrast, OKLab distance, red-green deficiency
  simulation) with the thresholds every palette is held to (`ColorThresholds`), light/dark color pairs, the palettes
  (`EarthPalette` with its tag colors, two series colors and a one-hue ramp for ranked steps; `ColorPalette`), the
  emphasis tokens (`Emphasis`: selection, highlight, chips, grid lines, outlines, separators, the floating card; one
  meaning, one value), the layout scales (`Spacing`, `LineWidth`, `CornerRadius`), the floating shadows
  (`FloatingShadow`) and the app's appearance choice (system, light, dark).
- `DesignKitUI` (SwiftUI and AppKit): the bridge from a light/dark pair or an emphasis to a `Color`, a status tone's
  background (`StatusTone.fill`), the surfaces (`popoverCard()`, `toastSurface()`, `cardSurface(bordered:)`), a
  shadow in a package style (`floatingShadow(_:)`), and applying the appearance choice to the running app.

## Use

```swift
.package(url: "https://github.com/its0fen/design-kit.git", exact: "0.7.0")
```

Add `DesignKitCore` and/or `DesignKitUI` to the target's dependencies.

## Tokens

| Token | Values |
| --- | --- |
| `Spacing` | `xxxs` 2, `xxs` 3, `xs` 4, `s` 6, `m` 8, `l` 10, `xl` 12, `xxl` 16, `xxxl` 20 (`Spacing.scale`, smallest first) |
| `LineWidth` | `hairline` 0.5 (grid lines), `thin` 0.75 (outlines), `regular` 1 (borders), `bold` 1.5 (gaps, marks) |
| `CornerRadius` | `small` 6 (rows, insets, floating cards), `large` 8 (banners, card surfaces) |
| `Emphasis` opacities | `toneFillOpacity` 0.12 (a status tone as background), `dimmedOpacity` 0.3 (a chart segment stepping back) |
| `FloatingShadow` | `popover` (radius 6, y 2, `Emphasis.popoverShadow`), `toast` (radius 4, y 1, `Emphasis.toastShadow`) |
| `CardSurfaceStyle` | `cornerRadius` = `CornerRadius.large`, `borderWidth` = `LineWidth.regular` |

A stack's `spacing` and a `padding` take a `Spacing` step; 0 needs no token. A width that follows from content (a
dialog, a column) stays the app's own: no common scale fits them. Names of the package's own colors and emphases are
English and never shown; the palettes' color names (`ColorPalette`, `EarthPalette.tagColors`) and palette names are
the ones an app may show a person, and stay as they are.

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
- An app names no hex value, opacity, corner radius, spacing, line width or shadow of its own: a value it needs is
  added here first.
- No SwiftUI macros (`@State`, `#Preview`, `@Entry`): they need Xcode.
