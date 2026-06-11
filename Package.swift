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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.0.1/BTXClientKit.xcframework.zip",
            checksum: "9ac7be78a35b378358b41e79e8f86db4174522f3944ed58736c35e884e90a5e8"
        ),
    ]
)
