// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MediaUtility",
    products: [
        .library(
            name: "MediaUtility",
            targets: ["MediaUtility"]),
        .library(
            name: "MediaTools",
            targets: ["MediaTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kojirou1994/Kwift.git", from: "0.3.1")
    ],
    targets: [
        .target(
            name: "MediaUtility",
            dependencies: ["KwiftExtension"]),
        .target(
            name: "MediaTools",
            dependencies: ["Executable", "MediaUtility"]
        ),
        .testTarget(
            name: "MediaUtilityTests",
            dependencies: ["MediaUtility"]),
    ]
)
