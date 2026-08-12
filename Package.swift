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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.1.0/BTXClientKit.xcframework.zip",
            checksum: "1e286be3a51d1984b45ab3e1f0bf3142404a68e139a68468a3bf7ad75f5fab77"
        ),
    ]
)
