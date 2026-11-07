// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BTXClientKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.5.3/BTXClientKit.xcframework.zip",
            checksum: "7102276ef6497cd93baa4079a631b4192efaa4369dfbc3e3effb5263d6eba0d0"
        ),
    ]
)
