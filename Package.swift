// swift-tools-version: 6.0
import Foundation
import PackageDescription

// swift-testing lives in the active developer directory. With Command Line Tools only (no Xcode),
// SwiftPM does not add that directory to its search paths, so `import Testing` fails to compile and
// the test executable fails to load Testing.framework's own lib_TestingInterop.dylib at runtime.
// Both paths below are therefore needed. Harmless when full Xcode is installed.
let developerRoot = "/Library/Developer/CommandLineTools/Library/Developer"
let developerFrameworks = developerRoot + "/Frameworks"
let developerLibraries = developerRoot + "/usr/lib"
let needsTestingFrameworkPath = FileManager.default.fileExists(
    atPath: developerFrameworks + "/Testing.framework"
)
let testingSwiftSettings: [SwiftSetting] = needsTestingFrameworkPath
    ? [.unsafeFlags(["-F", developerFrameworks])]
    : []
let testingLinkerSettings: [LinkerSetting] = needsTestingFrameworkPath
    ? [.unsafeFlags([
        "-F", developerFrameworks,
        "-Xlinker", "-rpath", "-Xlinker", developerFrameworks,
        "-Xlinker", "-rpath", "-Xlinker", developerLibraries,
      ])]
    : []

let package = Package(
    name: "DesignKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "DesignKitCore", targets: ["DesignKitCore"]),
        .library(name: "DesignKitUI", targets: ["DesignKitUI"]),
    ],
    targets: [
        .target(name: "DesignKitCore"),
        .target(name: "DesignKitUI", dependencies: ["DesignKitCore"]),
        // Deliberately an executable rather than a .testTarget — see Tests/DesignKitTests/TestRunner.swift.
        .executableTarget(
            name: "DesignKitTests",
            dependencies: ["DesignKitCore", "DesignKitUI"],
            path: "Tests/DesignKitTests",
            swiftSettings: testingSwiftSettings,
            linkerSettings: testingLinkerSettings
        ),
    ]
)
