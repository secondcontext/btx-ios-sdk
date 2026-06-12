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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.0.3/BTXClientKit.xcframework.zip",
            checksum: "ed546c2fad776b361ad395b8329ac39dab7bb58bbeed802b3c8021fff4e57853"
        ),
    ]
)
