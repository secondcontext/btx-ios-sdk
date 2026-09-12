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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.0.0/BTXClientKit.xcframework.zip",
            checksum: "53ae46eaecedc4ba07dff932c021f0229cffa98816413f03eaee3e672bc74289"
        ),
    ]
)
