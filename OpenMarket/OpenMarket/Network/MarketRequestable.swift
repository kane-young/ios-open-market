//
//  URLRequestProtocol.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/22.
//

import Foundation

protocol MarketRequestable: MultiPartProtocol {
  func createDeleteRequest(id: Int, with item: DeleteItem) -> Result<URLRequest, Error>
  func createPostRequest(with item: CreateItem) -> Result<URLRequest, Error>
  func createPatchRequest(id: Int, with item: UpdateItem) -> Result<URLRequest, Error>
}

extension MarketRequestable {
  func createDeleteRequest(id: Int, with item: DeleteItem) -> Result<URLRequest, Error> {
    guard let url = OpenMarketAPI.deleteProduct(id: id).url else {
      return .failure(OpenMarketError.invalidURL)
    }
        
    guard let data = try? JSONEncoder().encode(item) else {
      return .failure(OpenMarketError.encodingProblem)
    }
    
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.delete.description
    request.setValue(HttpMethod.createJsonContentType(), forHTTPHeaderField: HttpMethod.contentType)
    return .success(request)
  }
  
  func createPostRequest(with item: CreateItem) -> Result<URLRequest, Error> {
    guard let url = OpenMarketAPI.postProduct.url else {
      return .failure(OpenMarketError.invalidURL)
    }
    
    let data = createMultiPartBody(with: item)
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.post.description
    request.setValue(HttpMethod.createMultipartContentType(boundary: Self.boundary), forHTTPHeaderField: HttpMethod.contentType)
    return .success(request)
  }
  
  func createPatchRequest(id: Int, with item: UpdateItem) -> Result<URLRequest, Error> {
    guard let url = OpenMarketAPI.patchProduct(id: id).url else {
      return .failure(OpenMarketError.invalidURL)
    }
    
    let data = createMultiPartBody(with: item)
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.patch.description
    request.setValue(HttpMethod.createMultipartContentType(boundary: Self.boundary), forHTTPHeaderField: HttpMethod.contentType)
    return .success(request)
  }
}
