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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.0.2/BTXClientKit.xcframework.zip",
            checksum: "c36f2d2c23e72deca4b6e7882aacd8f37da10baf3215804ed743fdddd7f2ca7d"
        ),
    ]
)
