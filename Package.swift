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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.2.0/BTXClientKit.xcframework.zip",
            checksum: "ee325f25f233b47867896fa38b7993d726c5bee921d45d94120e56dc12be882f"
        ),
    ]
)
