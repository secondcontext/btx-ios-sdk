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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.2.1/BTXClientKit.xcframework.zip",
            checksum: "02d39bf802f8b72bc01969c530bd2d3373e7f6687fc7a347b3d3804c6bccfee3"
        ),
    ]
)
