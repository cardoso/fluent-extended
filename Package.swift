// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "more-fluent",
    dependencies: [
        .Package(url: "https://github.com/vapor/fluent.git", majorVersion: 2)
    ]
)
