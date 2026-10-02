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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/3.3.1/BTXClientKit.xcframework.zip",
            checksum: "0876a78db8b297ba85780fb5a612aa0be83d44885cdefcaf080b46c4466a66c5"
        ),
    ]
)
