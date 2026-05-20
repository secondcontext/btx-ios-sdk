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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.2.5/BTXClientKit.xcframework.zip",
            checksum: "21edb437515f9fcea78b6a9913ca8d9f5aa8d6ea4ba6f3dbf33bc07f2e41e19d"
        ),
    ]
)
