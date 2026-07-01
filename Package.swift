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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.1.2/BTXClientKit.xcframework.zip",
            checksum: "b2db4f7f9329195b3b72b2ec66ad8e6ace2ad20a5e76d8f85a145974e442f8ab"
        ),
    ]
)
