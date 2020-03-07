//
//  routes.swift
//  AudioWave
//
//  Created by Aaron Anthony on 2020-03-07.
//  Copyright © 2020 SphericalWave. All rights reserved.
//

import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  let acronymsController = AcronymsController()
  try router.register(collection: acronymsController)

  let usersController = UsersController()
  try router.register(collection: usersController)

  let categoriesController = CategoriesController()
  try router.register(collection: categoriesController)

  let websiteController = WebsiteController()
  try router.register(collection: websiteController)
}

