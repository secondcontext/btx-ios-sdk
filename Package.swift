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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.2.0/BTXClientKit.xcframework.zip",
            checksum: "a20c1a3c219b23ebf2d6e5ea48d8eca91075721e344be074374d0fc9efc4eb9b"
        ),
    ]
)
