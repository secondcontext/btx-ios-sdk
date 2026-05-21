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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.2.7/BTXClientKit.xcframework.zip",
            checksum: "9b3a71833ab005924cfe7cb66eb1ef319b92835ce363ea414e029d756f038f90"
        ),
    ]
)
