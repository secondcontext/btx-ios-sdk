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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.6.0/BTXClientKit.xcframework.zip",
            checksum: "e59c7c40dc03bdf3777135aefb48a431c8ebb5b08b07c160255886db065b2c12"
        ),
    ]
)
