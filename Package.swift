// swift-tools-version:5.0

//
//  Package.swift
//  AudioWave
//
//  Created by Aaron Anthony on 2020-03-07.
//  Copyright © 2020 SphericalWave. All rights reserved.
//

import PackageDescription

let package = Package(
  name: "FitWrench",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
    .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0")
  ],
  targets: [
    .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "Leaf"]),
    .target(name: "Run", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App"])
  ]
)
