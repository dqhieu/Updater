// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "Updater",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "Updater", targets: ["Updater"]),
  ],
  targets: [
    .target(
      name: "Updater",
      path: "Sources",
      exclude: [
        "Example"
      ]
    )
  ]
)
