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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.6.1/BTXClientKit.xcframework.zip",
            checksum: "b2efcd9862eb111c070750895486e43db144c2d46051f2e99a917b03d07a94fd"
        ),
    ]
)
