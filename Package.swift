// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "WormholeKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "WormholeKit",
            targets: ["WormholeKit"]
        ),
    ],
    targets: [
        .target(
            name: "WormholeKit",
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
            ]
        ),
    ]
)
