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

    public func readDependencies(isIncludeProduct: Bool) throws -> [Module] {
        let jsonString = try dumpPackage()
        let jsonData = jsonString.data(using: .utf8)!
        return try decoder
            .decode(DumpPackageResponse.self, from: jsonData)
            .toModule(isIncludeProduct: isIncludeProduct)
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
            let product: [String?]?
        }
    }
}

extension DumpPackageResponse {
    func toModule(isIncludeProduct: Bool) -> [Module] {
        targets.map { target in
            let byNameDependencies = target.dependencies.compactMap { $0.byName?.compactMap { $0 }.first }
            let productDependencies = target.dependencies.compactMap { $0.product?.compactMap { $0 }.first }
            let dependencies = isIncludeProduct ? byNameDependencies + productDependencies : byNameDependencies
            return Module(name: target.name, dependencies: dependencies)
        }
    }
}
#endif
