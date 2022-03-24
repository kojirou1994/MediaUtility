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
    .package(url: "https://github.com/kojirou1994/Kwift.git", from: "1.0.0"),
    .package(url: "https://github.com/kojirou1994/Executable.git", .upToNextMinor(from: "0.4.0")),
    .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", .upToNextMajor(from: "0.13.0"))
  ],
  targets: [
    .target(
      name: "MediaUtility",
      dependencies: [
      ]),
    .target(
      name: "MediaTools",
      dependencies: [
        .product(name: "KwiftExtension", package: "Kwift"),
        .product(name: "ExecutableLauncher", package: "Executable"),
        .product(name: "XMLCoder", package: "XMLCoder"),
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
