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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.2.1/BTXClientKit.xcframework.zip",
            checksum: "1509d5ed99955c382029d593bdff1cba63c452d0b9ba9bc8820bbdd1b4df3d42"
        ),
    ]
)
