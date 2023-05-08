// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-dependencies-graph",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "dgraph", targets: ["DependenciesGraph"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "DependenciesGraph",
            dependencies: [
                "DependenciesGraphCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(name: "DependenciesGraphCore"),
        .testTarget(
            name: "DependenciesGraphTests",
            dependencies: ["DependenciesGraphCore"]
        ),
    ]
)
