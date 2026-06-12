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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.0.4/BTXClientKit.xcframework.zip",
            checksum: "99fae738d0ccf7bdfd053af1e9324cba101b5297594b9d782476f872a539d11b"
        ),
    ]
)
