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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/2.0.0/BTXClientKit.xcframework.zip",
            checksum: "62281064c55f02636aff7db9c50cc3df92a936593af3beb5baa5e9b5642ce65e"
        ),
    ]
)
