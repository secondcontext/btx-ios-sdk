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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.9/BTXClientKit.xcframework.zip",
            checksum: "f9843d8609c76a321ac2ad2bdedb7d7e5408c3da71947df1633519d341bb10a6"
        ),
    ]
)
