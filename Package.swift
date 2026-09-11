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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.4.0/BTXClientKit.xcframework.zip",
            checksum: "7fb25befbb27afff68a11776e54ecd6b5d9ce6e3b23a7e0e79d5643928ec6f01"
        ),
    ]
)
