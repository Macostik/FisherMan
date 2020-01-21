//
//  Path+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation

enum PathError: Error, LocalizedError {
  case notFound
  case containerNotFound(String)

  var errorDescription: String? {
    switch self {
    case .notFound: return "Resource not found"
    case .containerNotFound(let id): return "Shared container for group \(id) not found"
    }
  }
}

class Path {
  static func inLibrary(_ name: String) throws -> URL {
    return try FileManager.default
      .url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }

  static func inDocuments(_ name: String) throws -> URL {
    return try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }

  static func inBundle(_ name: String) throws -> URL {
    guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
      throw PathError.notFound
    }
    return url
  }

  static func inSharedContainer(_ name: String) throws -> URL {
    guard let url = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: Constants.groupId) else {
        throw PathError.containerNotFound(Constants.groupId)
    }
    return url.appendingPathComponent(name)
  }

  static func documents() throws -> URL {
    return try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
  }
}
