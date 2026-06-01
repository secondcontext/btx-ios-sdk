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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.3/BTXClientKit.xcframework.zip",
            checksum: "88c7b207b6c1834ecf0873e9a06a5dd3fd6173a5d2b1ce9798783a39143192d7"
        ),
    ]
)
