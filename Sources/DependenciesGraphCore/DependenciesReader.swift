#if os(macOS)
import Foundation

public struct DependenciesReader {
    private let packageRootDirectoryPath: String
    private let decoder: JSONDecoder

    public init(
        packageRootDirectoryPath: String,
        decoder: JSONDecoder = .init()
    ) {
        self.packageRootDirectoryPath = packageRootDirectoryPath
        self.decoder = decoder
    }

    public func readDependencies() throws -> [Module] {
        let jsonString = try dumpPackage()
        let jsonData = jsonString.data(using: .utf8)!
        return try decoder
            .decode(DumpPackageResponse.self, from: jsonData)
            .toModule()
    }

    private func dumpPackage() throws -> String {
        try Command.run(
            launchPath: "/usr/bin/env",
            currentDirectoryPath: packageRootDirectoryPath,
            arguments: ["swift", "package", "dump-package"]
        )
    }
}

private struct DumpPackageResponse: Decodable {
    let targets: [Target]

    struct Target: Decodable {
        let name: String
        let dependencies: [Dependency]

        struct Dependency: Decodable {
            let byName: [String?]?
        }
    }
}

extension DumpPackageResponse {
    func toModule() -> [Module] {
        targets.map { target in
            let dependencies = target.dependencies.compactMap { $0.byName?.compactMap { $0 }.first }
            return Module(name: target.name, dependencies: dependencies)
        }
    }
}
#endif
