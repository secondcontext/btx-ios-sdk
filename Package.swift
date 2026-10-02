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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.3.0/BTXClientKit.xcframework.zip",
            checksum: "8fb1e5418452bd6bac8000058d897e8887e61d994cbc5f03421db96ec6ed0235"
        ),
    ]
)
