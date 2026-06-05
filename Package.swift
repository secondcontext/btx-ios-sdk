// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BTXClientKit",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "BTXClientKit",
            targets: ["BTXClientKit"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "BTXClientKit",
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.8/BTXClientKit.xcframework.zip",
            checksum: "e660f6b40ff61fbffbcd2b4c854e4ca99fb6627a3d80fcdd97c7e10410a605d5"
        ),
    ]
)
