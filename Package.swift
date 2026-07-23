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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.5.0/BTXClientKit.xcframework.zip",
            checksum: "ce76a0045c0ae52a477cdd558fee6b0840c4e265d7f4c02632c6f3b7c86eb5e6"
        ),
    ]
)
