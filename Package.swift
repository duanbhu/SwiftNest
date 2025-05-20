// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNest",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SwiftNest", targets: ["SwiftNest"]),
        .library(name: "RxSwiftNest", targets: ["RxSwiftNest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JoanKing/JKSwiftExtension.git", .upToNextMajor(from: "2.8.3")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftNest",
            dependencies: [
                .product(name: "JKSwiftExtension", package: "JKSwiftExtension")
            ]),
        .target(name: "RxSwiftNest", dependencies: [
            "RxSwift",
            .product(name: "RxCocoa", package: "RxSwift")
        ]),
        .testTarget(
            name: "SwiftNestTests",
            dependencies: ["SwiftNest"]
        ),
    ]
)
