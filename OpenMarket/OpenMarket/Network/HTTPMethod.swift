//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/18.
//

import Foundation

enum HTTPMethod: CustomStringConvertible {
  case get, post, put, patch, delete
  
  var description: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .patch:
      return "PATCH"
    case .delete:
      return "DELETE"
    }
  }
  
  static let contentType = "Content-Type"
  
  func makeHeaderContextType(boundary: String) -> String {
    switch self {
    case .get, .delete, .put:
      return "application/json"
    case .patch, .post:
      return "multipart/form-data; boundary=\(boundary)"
    }
  }
}
