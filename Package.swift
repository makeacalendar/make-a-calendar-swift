// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MakeACalendarCraft",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [.library(name: "MakeACalendarCraft", targets: ["MakeACalendarCraft"])],
    targets: [
        .target(name: "MakeACalendarCraft"),
        .testTarget(name: "MakeACalendarCraftTests", dependencies: ["MakeACalendarCraft"])
    ]
)
