//
//  URLRequestProtocol.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/22.
//

import Foundation

protocol MarketRequestable: MultiPartProtocol {
  func createJsonFormRequest<T: Encodable>(url: URL, _ httpMethod: HttpMethod, with item: T) -> URLRequest?
  func createMultiPartFormRequest<T: Encodable>(url: URL, _ httpMethod: HttpMethod, with item: T) -> URLRequest?
}

extension MarketRequestable {
  func createJsonFormRequest<T: Encodable>(url: URL, _ httpMethod: HttpMethod, with item: T) -> URLRequest? {
    guard let data = try? JSONEncoder().encode(item) else {
      return nil
    }
    
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = httpMethod.description
    request.setValue(HttpMethod.createJsonContentType(), forHTTPHeaderField: HttpMethod.contentType)
    return request
  }
  
  func createMultiPartFormRequest<T: Encodable>(url: URL, _ httpMethod: HttpMethod, with item: T) -> URLRequest? {
    let data = createMultiPartBody(with: item)
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = httpMethod.description
    request.setValue(HttpMethod.createMultipartContentType(boundary: Self.boundary), forHTTPHeaderField: HttpMethod.contentType)
    return request
  }
}
