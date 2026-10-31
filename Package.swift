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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.4/BTXClientKit.xcframework.zip",
            checksum: "35726c3a714b11fd3321921079cd1afd0333c9e53d28f433dbd29987ad53fca7"
        ),
    ]
)
