import PackageDescription

let package = Package(
    name: "ReAnimation",
    products: [
        .library(
            name: "ReAnimation",
            targets: ["ReAnimation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "ReAnimation",
            dependencies: ["RxSwift", "RxCocoa"]),
        .testTarget(
            name: "ReAnimationTest",
            dependencies: ["ReactiveAnimation", "RxSwift", "Quick", "Nimble"]),
    ]
)
