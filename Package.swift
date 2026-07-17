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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.2.0/BTXClientKit.xcframework.zip",
            checksum: "368339c1c662c5d52e8f5985e3a5d4a28ad23da7909a80af24036a6cf0769567"
        ),
    ]
)
