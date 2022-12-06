// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubAPIClient",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "GitHubAPIClient",
            targets: ["GitHubAPIClient"])
    ],
    dependencies: [
        .package(name: "Model", path: "../Model"),
        .package(name: "Networking", path: "../Networking")
    ],
    targets: [
        .target(
            name: "GitHubAPIClient",
            dependencies: [
                "Model",
                "Networking"
            ],
            resources: [
                .process("Resources/colors.json")
            ]
        ),
        .testTarget(
            name: "GitHubAPIClientTests",
            dependencies: [
                "GitHubAPIClient",
                "Model",
                "Networking"
            ],
            resources: [
                .copy("Files/officialReposResponse.json"),
                .copy("Files/unofficialReposResponse.json")
            ]
        )
    ]
)
