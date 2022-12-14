// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Penumbra",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Penumbra", targets: ["Penumbra"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", exact: "0.15.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Penumbra", dependencies: []),
        .testTarget(name: "PenumbraTests", dependencies: ["Penumbra"]),

        // TODO: implement as a custom build plugin once source dependencies are supported
        .executableTarget(name: "PenumbraGenerator",
                          dependencies: [
                            .product(name: "Stencil", package: "Stencil")
                          ],
                          resources: [
                            .process("penumbra.tsv"),
                            .process("Templates")
                          ])
    ]
)
