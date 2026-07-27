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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.5.1/BTXClientKit.xcframework.zip",
            checksum: "9d9b9d1f8be1e687ab54ff0c50271f353de6b991786d53d6c3aa0b1ef31d4e30"
        ),
    ]
)
