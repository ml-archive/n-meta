// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NMeta",
    products: [
        .library(
            name: "NMeta",
            targets: ["NMeta"]),
    ],
    dependencies: [        
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "NMeta",
            dependencies: [
                "Vapor"
            ]),
        .testTarget(
            name: "NMetaTests",
            dependencies: ["NMeta"]),
    ]
)
