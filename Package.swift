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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.3.0/BTXClientKit.xcframework.zip",
            checksum: "66cea1ba12f2934d6351e1d166e3def3e352cc7ffb2ad601ad9c41e4014ba905"
        ),
    ]
)
