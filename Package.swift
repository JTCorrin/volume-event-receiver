// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VolumeEventReceiver",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "VolumeEventReceiver",
            targets: ["VolumeEventReceiverPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "VolumeEventReceiverPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/VolumeEventReceiverPlugin"),
        .testTarget(
            name: "VolumeEventReceiverPluginTests",
            dependencies: ["VolumeEventReceiverPlugin"],
            path: "ios/Tests/VolumeEventReceiverPluginTests")
    ]
)