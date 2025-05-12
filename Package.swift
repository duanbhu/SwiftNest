// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNest",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftNest",
            targets: ["SwiftNest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JoanKing/JKSwiftExtension.git", .upToNextMajor(from: "2.8.3"))
    ],
    targets: [
        .target(
            name: "SwiftNest",
            dependencies: [
                .product(name: "JKSwiftExtension", package: "JKSwiftExtension")
            ]),
        .testTarget(
            name: "SwiftNestTests",
            dependencies: ["SwiftNest"]
        ),
    ]
)
