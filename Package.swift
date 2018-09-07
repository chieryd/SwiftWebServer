// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebService",
    dependencies:  [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-MongoDB.git", from: "3.0.0")
        
//        .package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0"),
//        .package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", from: "3.0.0"),
//        .package(url: "https://github.com/SwiftORM/MySQL-StORM.git", from: "3.0.0"),
//        .package(url: "https://github.com/PerfectlySoft/Perfect-Session-MySQL.git", from: "3.0.0"),
        ],
    targets: [
        .target(
            name: "WebService",
            dependencies: ["PerfectHTTPServer", "PerfectMongoDB"/*, "PerfectMySQL", "PerfectRequestLogger", "MySQLStORM", "PerfectSessionMySQL"*/]),
    ]
)
