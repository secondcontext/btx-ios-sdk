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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.6/BTXClientKit.xcframework.zip",
            checksum: "0059feb2a2c9fa90dd93a11d35544f5823ce67a8c2fc5ea0bd490ceee6dba1b0"
        ),
    ]
)
