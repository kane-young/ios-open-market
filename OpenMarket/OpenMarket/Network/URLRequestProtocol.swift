//
//  RequestManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

protocol URLRequestProtocol {
  static var boundary: String { get }
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) throws -> URLRequest
}

extension URLRequestProtocol {
  static var boundary: String {
    return UUID().uuidString
  }
  
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) throws -> URLRequest {
    guard let url = apiRequestType.url else {
      throw OpenMarketError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    let contentType = httpMethod.makeContentTypeText(boundary: Self.boundary)
    
    urlRequest.httpMethod = httpMethod.description
    urlRequest.setValue(contentType, forHTTPHeaderField: HttpMethod.contentType)
    
    return urlRequest
  }
}
