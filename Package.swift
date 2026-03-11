// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Magi",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Magi", targets: ["Magi"]),
    ],
    targets: [
        .target(name: "Magi"),
        .executableTarget(
            name: "MagiShowcase",
            dependencies: ["Magi"]
        ),
    ]
)
