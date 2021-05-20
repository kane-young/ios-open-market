//
//  RequestManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation
//
//  URLRequestManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/18.
//

import Foundation

final class URLRequestManager {
  static let boundary = UUID().uuidString
  
  static func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) throws -> URLRequest {
    guard let url = apiRequestType.url else {
      throw OpenMarketError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    let contentType = httpMethod.makeContentTypeText(boundary: boundary)
    
    urlRequest.httpMethod = httpMethod.description
    urlRequest.setValue(contentType, forHTTPHeaderField: HttpMethod.contentType)
    
    return urlRequest
  }
}

