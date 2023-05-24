import Foundation
import ArgumentParser
import DependenciesGraphCore

@main
struct DependenciesGraph: ParsableCommand {
    @Argument(help: "Project root directory")
    var projectPath: String

    @Flag(name: .customLong("add-to-readme"), help: "Add Mermaid diagram to README")
    var isAddToReadme: Bool = false

    static let _commandName: String = "dgraph"
    
    private var fileManager: FileManager { FileManager.default }

    mutating func run() throws {
        #if os(macOS)
        if isAddToReadme {
            try addToReadme()
        } else {
            try createPackageDependencies()
        }
        #endif
    }

    mutating func validate() throws {
        if !URL(fileURLWithPath: projectPath).hasDirectoryPath {
            throw DependenciesGraphError.notDirectory(path: projectPath)
        }
        else if !fileManager.fileExists(atPath: projectPath) {
            throw DependenciesGraphError.projectNotFound(path: projectPath)
        }
        else if !fileManager.fileExists(atPath: projectPath + "/Package.swift") {
            throw DependenciesGraphError.packageSwiftNotFound(path: projectPath)
        }
        else if !fileManager.fileExists(atPath: projectPath + "/README.md") && isAddToReadme {
            throw DependenciesGraphError.readmeNotFound
        }
    }

    private func addToReadme() throws {
        let mermaid = try createMermaid()
        let readmeTitle = "## Package Dependencies"
        let url = URL(fileURLWithPath: projectPath).appendingPathComponent("README.md")
        if !fileManager.fileExists(atPath: url.absoluteString) {
            fileManager.createFile(atPath: url.absoluteString, contents: nil)
        }
        guard var readme = try String(data: Data(contentsOf: url), encoding: .utf8) else {
            throw DependenciesGraphError.failedToDecodeReadme
        }
        let removedReadme = ReadmeReader.removeLines(readme, from: "## Package Dependencies")
        readme = removedReadme + readmeTitle + "\n" + mermaid
        try readme.write(to: url, atomically: true, encoding: .utf8)
        print("✅ Updated README.md")
    }

    private func createPackageDependencies() throws {
        let mermaid = try createMermaid()
        let url = URL(fileURLWithPath: projectPath).appendingPathComponent("PackageDependencies.md")
        try mermaid.write(to: url, atomically: true, encoding: .utf8)
        print("✅ Created PackageDependencies.md")
    }

    private func createMermaid() throws -> String {
        print("🚀 Reading dependencies...")
        let reader = DependenciesReader(packageRootDirectoryPath: projectPath)
        let modules = try reader.readDependencies()
        print("🧜 Creating Mermaid...")
        let mermaid = MermaidCreator.create(from: modules)
        return mermaid
    }
}

enum DependenciesGraphError: LocalizedError {
    case projectNotFound(path: String)
    case packageSwiftNotFound(path: String)
    case notDirectory(path: String)
    case readmeNotFound
    case failedToDecodeReadme

    var errorDescription: String? {
        switch self {
        case .projectNotFound(let path):
            return "\(path) could not be found"

        case .packageSwiftNotFound(let path):
            return "\(path)/Package.swift could not be found"

        case .notDirectory(let path):
            return "\(path) is not a directory"

        case .readmeNotFound:
            return "README.md could not be found"

        case .failedToDecodeReadme:
            return "Failed to decode README.md"
        }
    }
}
