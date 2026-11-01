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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.5/BTXClientKit.xcframework.zip",
            checksum: "73b6853479e1eda71bd3213d0aec59c53dc1700e9cd124fc03c8439d66272105"
        ),
    ]
)
