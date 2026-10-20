import Foundation
import Testing

@Suite("The package knows no application")
struct PackageSourceTests {
    static let forbiddenWords = [
        "ReviewCore", "FinanzbuchhaltungApp", "Notwendigkeit", "Kategorie", "Fixkosten", "Konto", "Gegenpartei", "cents",
    ]

    /// A path into a person's home folder in a string literal ties the package to one machine.
    static let forbiddenMachinePath = "\"/Users/"

    private static var sourcesDirectory: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Sources", isDirectory: true)
    }

    private static func swiftFiles(in directory: URL) -> [URL] {
        FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)?
            .compactMap { $0 as? URL }.filter { $0.pathExtension == "swift" } ?? []
    }

    static func offenders(in directory: URL) -> [String] {
        swiftFiles(in: directory).flatMap { file -> [String] in
            let original = (try? String(contentsOf: file, encoding: .utf8)) ?? ""
            let text = original.lowercased()
            let words = forbiddenWords.filter { text.contains($0.lowercased()) }
            let paths = original.contains(forbiddenMachinePath) ? [forbiddenMachinePath] : []
            return (words + paths).map { "\(file.lastPathComponent): \($0)" }
        }.sorted()
    }

    @Test func noSourceFileNamesADomainWordOrAnApplicationModule() {
        #expect(Self.offenders(in: Self.sourcesDirectory) == [])
    }

    @Test func aPlantedHomeFolderIsReported() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        try Data("let folder = \"/Users/someone/Git\"\n".utf8).write(to: directory.appendingPathComponent("Planted.swift"))

        #expect(Self.offenders(in: directory) == ["Planted.swift: \"/Users/"])
    }

    @Test func theSourcesDirectoryIsActuallyScanned() {
        let names = Self.swiftFiles(in: Self.sourcesDirectory).map(\.lastPathComponent)
        #expect(names.contains("ColorMath.swift"))
    }

    @Test func aPlantedDomainWordIsReported() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        try Data("import ReviewCore\nlet total: Int = amountCents\n".utf8).write(to: directory.appendingPathComponent("Planted.swift"))

        #expect(Self.offenders(in: directory) == ["Planted.swift: ReviewCore", "Planted.swift: cents"])
    }
}
