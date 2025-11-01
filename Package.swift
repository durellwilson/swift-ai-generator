// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftAIGenerator",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "SwiftAIGenerator", targets: ["SwiftAIGenerator"]),
    ],
    targets: [
        .target(name: "SwiftAIGenerator"),
        .testTarget(name: "SwiftAIGeneratorTests", dependencies: ["SwiftAIGenerator"]),
    ]
)
