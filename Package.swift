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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.1.1/BTXClientKit.xcframework.zip",
            checksum: "54d9e1445dfa9847b568959b3d37745acfe9337ff3c1f1ffd29cb6f348b91d10"
        ),
    ]
)
