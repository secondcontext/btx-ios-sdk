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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.8.1/BTXClientKit.xcframework.zip",
            checksum: "5a4fd7bd01697a4e0385fdb7905863ae23d48d189df9ac217605ae3c6eb349b7"
        ),
    ]
)
