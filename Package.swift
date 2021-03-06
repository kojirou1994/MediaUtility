// swift-tools-version:5.4

import PackageDescription

let package = Package(
  name: "MediaUtility",
  platforms: [
    .macOS(.v10_13)
  ],
  products: [
    .library(
      name: "MediaUtility",
      targets: ["MediaUtility"]),
    .library(
      name: "MediaTools",
      targets: ["MediaTools"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kojirou1994/Kwift.git", from: "0.8.0"),
    .package(url: "https://github.com/kojirou1994/Executable.git", .upToNextMinor(from: "0.4.0")),
    .package(url: "https://github.com/kojirou1994/XMLParsing.git", .upToNextMinor(from: "0.1.0"))
  ],
  targets: [
    .target(
      name: "MediaUtility",
      dependencies: [
        .product(name: "KwiftExtension", package: "Kwift"),
      ]),
    .target(
      name: "MediaTools",
      dependencies: [
        .product(name: "ExecutableLauncher", package: "Executable"),
        .product(name: "XMLParsing", package: "XMLParsing"),
        .target(name: "MediaUtility"),
      ]),
    .testTarget(
      name: "MediaUtilityTests",
      dependencies: [
        .target(name: "MediaUtility"),
        .target(name: "MediaTools"),
      ]),
  ]
)
