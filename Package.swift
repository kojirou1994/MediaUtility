// swift-tools-version:5.2

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
        .package(url: "https://github.com/kojirou1994/Kwift.git", from: "0.5.0"),
        .package(url: "git@github.com:kojirou1994/Executable.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "MediaUtility",
            dependencies: [.product(name: "KwiftExtension", package: "Kwift")]),
        .target(
            name: "MediaTools",
            dependencies: ["Executable", "MediaUtility"]
        ),
        .testTarget(
            name: "MediaUtilityTests",
            dependencies: ["MediaUtility", "MediaTools"]),
    ]
)
