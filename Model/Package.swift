// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Model",
            targets: ["Model"])
    ],
    targets: [
        .target(name: "Model")
    ]
)
