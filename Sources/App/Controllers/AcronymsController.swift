//
//  Acronyms.swift
//  AudioWave
//
//  Created by Aaron Anthony on 2020-03-07.
//  Copyright © 2020 SphericalWave. All rights reserved.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
  func boot(router: Router) throws {
    let acronymsRoutes = router.grouped("api", "acronyms")
    acronymsRoutes.get(use: getAllHandler)
    acronymsRoutes.post(Acronym.self, use: createHandler)
    acronymsRoutes.get(Acronym.parameter, use: getHandler)
    acronymsRoutes.put(Acronym.parameter, use: updateHandler)
    acronymsRoutes.delete(Acronym.parameter, use: deleteHandler)
    acronymsRoutes.get("search", use: searchHandler)
    acronymsRoutes.get("first", use: getFirstHandler)
    acronymsRoutes.get("sorted", use: sortedHandler)
    acronymsRoutes.get(Acronym.parameter, "user", use: getUserHandler)
    acronymsRoutes.post(Acronym.parameter, "categories", Category.parameter, use: addCategoriesHandler)
    acronymsRoutes.get(Acronym.parameter, "categories", use: getCategoriesHandler)
    acronymsRoutes.delete(Acronym.parameter, "categories", Category.parameter, use: removeCategoriesHandler)
  }

  func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
    return Acronym.query(on: req).all()
  }

  func createHandler(_ req: Request, acronym: Acronym) throws -> Future<Acronym> {
    return acronym.save(on: req)
  }

  func getHandler(_ req: Request) throws -> Future<Acronym> {
    return try req.parameters.next(Acronym.self)
  }

  func updateHandler(_ req: Request) throws -> Future<Acronym> {
    return try flatMap(to: Acronym.self,
                       req.parameters.next(Acronym.self),
                       req.content.decode(Acronym.self)) { acronym, updatedAcronym in
      acronym.short = updatedAcronym.short
      acronym.long = updatedAcronym.long
      acronym.userID = updatedAcronym.userID
      return acronym.save(on: req)
    }
  }

  func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Acronym.self).delete(on: req).transform(to: .noContent)
  }

  func searchHandler(_ req: Request) throws -> Future<[Acronym]> {
    guard let searchTerm = req.query[String.self, at: "term"] else {
      throw Abort(.badRequest)
    }
    return Acronym.query(on: req).group(.or) { or in
      or.filter(\.short == searchTerm)
      or.filter(\.long == searchTerm)
      }.all()
  }

  func getFirstHandler(_ req: Request) throws -> Future<Acronym> {
    return Acronym.query(on: req).first().unwrap(or: Abort(.notFound))
  }

  func sortedHandler(_ req: Request) throws -> Future<[Acronym]> {
    return Acronym.query(on: req).sort(\.short, .ascending).all()
  }

  func getUserHandler(_ req: Request) throws -> Future<User> {
    return try req.parameters.next(Acronym.self).flatMap(to: User.self) { acronym in
      acronym.user.get(on: req)
    }
  }

  func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
    return try flatMap(to: HTTPStatus.self, req.parameters.next(Acronym.self),
                       req.parameters.next(Category.self)) { acronym, category in
      return acronym.categories.attach(category, on: req).transform(to: .created)
    }
  }

  func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
    return try req.parameters.next(Acronym.self).flatMap(to: [Category].self) { acronym in
      try acronym.categories.query(on: req).all()
    }
  }

  func removeCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
    return try flatMap(to: HTTPStatus.self, req.parameters.next(Acronym.self),
                       req.parameters.next(Category.self)) { acronym, category in
      return acronym.categories.detach(category, on: req).transform(to: .noContent)
    }
  }
}

