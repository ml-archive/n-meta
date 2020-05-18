// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "n-meta",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "NMeta", targets: ["NMeta"])
    ],

    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        
        .target(
            name: "NMeta",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]),
        .testTarget(name: "NMetaTests", dependencies: [
            .target(name: "NMeta"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
