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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.5/BTXClientKit.xcframework.zip",
            checksum: "ad0929d44adab5745dd65edd1164389adebdb7e130ed3d13f6e8d0f0b4a12674"
        ),
    ]
)
