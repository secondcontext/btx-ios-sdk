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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.5.1/BTXClientKit.xcframework.zip",
            checksum: "ea09b3d1b0ba5cd87881c3a9d88f29f68c805addc7ac8dd7133f0810fae94b2b"
        ),
    ]
)
