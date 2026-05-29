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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.0/BTXClientKit.xcframework.zip",
            checksum: "d2c7c84fdc0f10e3e043d260758394d69b6ee26f7725534bab9066f5b6a5593e"
        ),
    ]
)
