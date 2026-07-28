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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.5.3/BTXClientKit.xcframework.zip",
            checksum: "0d55defef3573f985126c59d378c1c8199288e4a8b604fa0fee75eb4e7e6f467"
        ),
    ]
)
