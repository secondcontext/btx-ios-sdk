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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.4.3/BTXClientKit.xcframework.zip",
            checksum: "ee7ce83c04fb5626dd02c148c7d792ab63727115b6f600c2ad76bb8d8649b3dc"
        ),
    ]
)
