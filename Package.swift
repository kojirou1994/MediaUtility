// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "MediaUtility",
  platforms: [
    .macOS(.v10_15)
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
    .package(url: "https://github.com/kojirou1994/Kwift.git", .upToNextMinor(from: "0.6.0")),
    .package(url: "git@github.com:kojirou1994/Executable.git", from: "0.0.1"),
    .package(url: "https://github.com/ShawnMoore/XMLParsing.git", from: "0.0.3")
  ],
  targets: [
    .target(
      name: "MediaUtility",
      dependencies: [.product(name: "KwiftExtension", package: "Kwift")]),
    .target(
      name: "MediaTools",
      dependencies: ["Executable", "MediaUtility", "XMLParsing"]
    ),
    .testTarget(
      name: "MediaUtilityTests",
      dependencies: ["MediaUtility", "MediaTools"]),
  ]
)
