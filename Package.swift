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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.3.0/BTXClientKit.xcframework.zip",
            checksum: "1f59302fb6f54d6f24f62f734a251cee6b2900b26a61477fd8cb176753966724"
        ),
    ]
)
