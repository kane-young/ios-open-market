//
//  URLRequestManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/18.
//

import Foundation

final class URLRequestProvider {
  static let boundary = UUID().uuidString
  
  static func makeURLRequest(httpMethod: HTTPMethod, apiRequestType: APIRequestType = .loadPage(page: 1)) throws -> URLRequest {
    guard let url = apiRequestType.url else {
      throw OpenMarketError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    let contentType = httpMethod.makeHeaderContextType(boundary: boundary)
    
    urlRequest.httpMethod = httpMethod.description
    urlRequest.setValue(contentType, forHTTPHeaderField: HTTPMethod.contentType)
    
    return urlRequest
  }
}
