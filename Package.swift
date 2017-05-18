import PackageDescription

let package = Package(
        name: "Meta",
        dependencies: [
                .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        ]
)
