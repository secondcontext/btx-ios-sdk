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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.1.1/BTXClientKit.xcframework.zip",
            checksum: "5d785a689704272b29df35e2b34aab3f7c994c79aa6b16080f7c33d4c899a23e"
        ),
    ]
)
