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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.2/BTXClientKit.xcframework.zip",
            checksum: "dd0cc496a368f1ed50ac6e854aea8e7327e5a3830d455b3b96a7d287506387fb"
        ),
    ]
)
