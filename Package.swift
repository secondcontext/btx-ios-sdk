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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.1.0/BTXClientKit.xcframework.zip",
            checksum: "ad0b0dbdcada484b097d9e7146108e4120779d519ead221dfcd55ed3b0043e6e"
        ),
    ]
)
