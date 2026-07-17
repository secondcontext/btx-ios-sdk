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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.4.0/BTXClientKit.xcframework.zip",
            checksum: "2239c032cb65c02902dd6916cd994d10c166b2770a6131caf5d1023f0301824d"
        ),
    ]
)
