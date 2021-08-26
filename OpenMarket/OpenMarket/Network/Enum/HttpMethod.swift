//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

enum HttpMethod: CustomStringConvertible {
  case get, post, patch, delete
  
  var description: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .patch:
      return "PATCH"
    case .delete:
      return "DELETE"
    }
  }
  
  static let contentType = "Content-Type"

  static func createJsonContentType() -> String {
    return "Application/json"
  }
  
  static func createMultipartContentType(boundary: String) -> String {
    return "multipart/form-data; boundary=\(boundary)"
  }
}
