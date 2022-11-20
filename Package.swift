// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ElementIo",
    platforms: [.macOS(.v12)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ElementIo",
            dependencies: []),
        .testTarget(
            name: "ElementIoTests",
            dependencies: ["ElementIo"]),
    ]
)
