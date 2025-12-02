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
    targets: [
        .target(
            name: "Env",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "EnvTests",
            dependencies: ["Env"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        )
    ]
)
