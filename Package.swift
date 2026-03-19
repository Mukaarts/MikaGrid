// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MikaGrid",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "MikaGrid",
            path: "Sources",
            linkerSettings: [
                .linkedFramework("Carbon"),
                .linkedFramework("ApplicationServices"),
            ]
        )
    ]
)
