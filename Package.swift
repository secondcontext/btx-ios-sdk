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
            url: "https://github.com/secondcontext/btx-ios-sdk/releases/download/1.5.2/BTXClientKit.xcframework.zip",
            checksum: "890343c2597fa5724217f615293baaa04b6868017454a99a50fd82c67d14eabe"
        ),
    ]
)
