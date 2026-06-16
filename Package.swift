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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.1.0/BTXClientKit.xcframework.zip",
            checksum: "f4a57d5b6ba88dec993e8fadeab99c4d57ea1304edb7c45dad7d9fcdc22050d7"
        ),
    ]
)
