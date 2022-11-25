// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transitionable",
    products: [
        .library(name: "Transitionable",
                 targets: ["Transitionable"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Transitionable",
                dependencies: [])
    ]
)
