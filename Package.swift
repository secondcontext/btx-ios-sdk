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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.0.0/BTXClientKit.xcframework.zip",
            checksum: "ade208409cf8920c4fea2e627c1f7bbf8377f3dc3aeefe178d4da1fd8d418915"
        ),
    ]
)
