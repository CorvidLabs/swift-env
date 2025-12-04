// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-env",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Env", targets: ["Env"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3")
    ],
    targets: [
        .target(name: "Env"),
        .testTarget(
            name: "EnvTests",
            dependencies: ["Env"]
        )
    ]
)
