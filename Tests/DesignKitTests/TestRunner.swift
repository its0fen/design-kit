import Testing

/// Runs the suites in this target.
///
/// This machine has Command Line Tools but no Xcode, so there is no `xctest` runner for the
/// `.xctest` bundle that `swift test` produces — it loads nothing, reports nothing, and still exits
/// 0, which is a false green. Building the tests as an ordinary executable that calls swift-testing
/// directly makes the result trustworthy. Run them with
/// `swift run --build-system native --package-path . DesignKitTests` — the default `swiftbuild`
/// engine cannot load the swift-testing macro plugin from the Command Line Tools (see README.md).
@main
enum TestRunner {
    static func main() async {
        await Testing.__swiftPMEntryPoint() as Never
    }
}
