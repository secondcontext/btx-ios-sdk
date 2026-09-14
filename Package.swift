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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.0.1/BTXClientKit.xcframework.zip",
            checksum: "efe03d36f617683bca9866a462ff324c213b6fd4683b9a136b2107c584018dbc"
        ),
    ]
)
