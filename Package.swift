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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.1/BTXClientKit.xcframework.zip",
            checksum: "cf1990613cd6b7872c176b75e730f161deed1a38a88786eaa3d3c6ed0e0096b7"
        ),
    ]
)
