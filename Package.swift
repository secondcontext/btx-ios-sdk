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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.4/BTXClientKit.xcframework.zip",
            checksum: "2d842842c49db6d31c498be17c482c98a4cae0d7290fe5754f8834ed84525f09"
        ),
    ]
)
