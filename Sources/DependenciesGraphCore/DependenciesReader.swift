import Foundation

public protocol DumpPackage: Sendable {
    func dumpPackage(
        packageRootDirectoryPath: String?
    ) throws -> String
}

extension DumpPackage where Self == DumpPackageDefault {
    public static var `default`: any DumpPackage { DumpPackageDefault() }
}

public struct DumpPackageDefault: DumpPackage {
    public func dumpPackage(
        packageRootDirectoryPath: String? = nil
    ) throws -> String {
        try Command.run(
            launchPath: "/usr/bin/env",
            currentDirectoryPath: packageRootDirectoryPath,
            arguments: ["swift", "package", "dump-package"]
        )
    }
}

public struct DependenciesReader {
    private let packageRootDirectoryPath: String
    private let decoder: JSONDecoder
    private let dumpPackage: any DumpPackage

    public init(
        packageRootDirectoryPath: String,
        decoder: JSONDecoder = .init(),
        dumpPackage: any DumpPackage = .default
    ) {
        self.packageRootDirectoryPath = packageRootDirectoryPath
        self.decoder = decoder
        self.dumpPackage = dumpPackage
    }

    public func readDependencies(isIncludeProduct: Bool) throws -> [Module] {
        let jsonString = try dumpPackage.dumpPackage(
            packageRootDirectoryPath: packageRootDirectoryPath
        )
        let jsonData = jsonString.data(using: .utf8)!
        return try decoder
            .decode(DumpPackageResponse.self, from: jsonData)
            .toModule(isIncludeProduct: isIncludeProduct)
    }
}

struct DumpPackageResponse: Decodable {
    let targets: [Target]

    struct Target: Decodable {
        let name: String
        let dependencies: [Dependency]

        struct Dependency: Decodable {
            let target: [String?]?
            let product: [String?]?
            let byName: [String?]?

            private enum CodingKeys: String, CodingKey {
                case target
                case product
                case byName
            }

            init(target: [String?]?, product: [String?]?, byName: [String?]? = nil) {
                // Normalize so that `target` and `byName` always reflect the same underlying value.
                let effectiveByName = byName ?? target
                self.byName = effectiveByName
                self.target = effectiveByName
                self.product = product
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let decodedTarget = try container.decodeIfPresent([String?].self, forKey: .target)
                let decodedByName = try container.decodeIfPresent([String?].self, forKey: .byName)
                let effectiveByName = decodedByName ?? decodedTarget
                self.byName = effectiveByName
                self.target = effectiveByName
                self.product = try container.decodeIfPresent([String?].self, forKey: .product)
            }
        }
    }
}

extension DumpPackageResponse {
    func toModule(isIncludeProduct: Bool) -> [Module] {
        targets.map { target in
            let byNameDependencies = target.dependencies.compactMap { $0.byName?.compactMap(\.self).first }.sorted()
            let productDependencies = target.dependencies.compactMap { $0.product?.compactMap(\.self).first }.sorted()
            let dependencies = isIncludeProduct ? byNameDependencies + productDependencies : byNameDependencies
            return Module(name: target.name, dependencies: dependencies)
        }.sorted { $0.name < $1.name }
    }
}
