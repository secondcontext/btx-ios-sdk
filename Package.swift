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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.0/BTXClientKit.xcframework.zip",
            checksum: "efa6d2d070683ea1230665e0295d6ae3b0bd5399011dca640450e3f6e612aab3"
        ),
    ]
)
