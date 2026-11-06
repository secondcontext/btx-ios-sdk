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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.5.2/BTXClientKit.xcframework.zip",
            checksum: "4fdec184ee779e1a54d1698485aeae1e44df25553062ecaa1da983eff7b2bb63"
        ),
    ]
)
