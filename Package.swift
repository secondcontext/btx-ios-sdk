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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/0.3.7/BTXClientKit.xcframework.zip",
            checksum: "f360c2ed8da27cd2985c3e4bf247a2b491e507421880c886b9f4143e195f8533"
        ),
    ]
)
