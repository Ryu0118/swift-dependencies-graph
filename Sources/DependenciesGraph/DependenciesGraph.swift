import Foundation
import ArgumentParser
import DependenciesGraphCore

@main
struct DependenciesGraph: ParsableCommand {
    @Argument(help: "Project root directory")
    var projectPath: String

    static let _commandName: String = "dgraph"

    mutating func run() throws {
        #if os(macOS)
        print("🚀 Reading dependencies...")
        let reader = DependenciesReader(packageRootDirectoryPath: projectPath)
        let modules = try reader.readDependencies()
        print("🧜 Creating Mermaid...")
        let mermaid = MermaidCreator.create(from: modules)
        let url = URL(fileURLWithPath: projectPath)
            .appendingPathComponent("PackageDependencies.md")
        try mermaid.write(to: url, atomically: true, encoding: .utf8)
        print("✅ Succeeded!!")
        #endif
    }

    mutating func validate() throws {
        if !URL(fileURLWithPath: projectPath).hasDirectoryPath {
            throw DependenciesGraphError.notDirectory(path: projectPath)
        }
        else if !FileManager.default.fileExists(atPath: projectPath) {
            throw DependenciesGraphError.projectNotFound(path: projectPath)
        }
        else if !FileManager.default.fileExists(atPath: projectPath + "/Package.swift") {
            throw DependenciesGraphError.packageSwiftNotFound(path: projectPath)
        }
    }
}

enum DependenciesGraphError: LocalizedError {
    case projectNotFound(path: String)
    case packageSwiftNotFound(path: String)
    case notDirectory(path: String)

    var errorDescription: String? {
        switch self {
        case .projectNotFound(let path):
            return "\(path) could not be found"

        case .packageSwiftNotFound(let path):
            return "\(path)/Package.swift could not be found"

        case .notDirectory(let path):
            return "\(path) is not a directory"
        }
    }
}
