//
//  URLRequestProtocol.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/22.
//

import Foundation

protocol MarketRequestable: MultiPartProtocol {
  func createDeleteRequest(id: Int, with item: DeleteItem) -> URLRequest?
  func createPostRequest(with item: CreateItem) -> URLRequest?
  func createPatchRequest(id: Int, with item: UpdateItem) -> URLRequest?
}

extension MarketRequestable {
  func createDeleteRequest(id: Int, with item: DeleteItem) -> URLRequest? {
    guard let url = OpenMarketAPI.deleteProduct(id: id).url else {
      return nil
    }
        
    guard let data = try? JSONEncoder().encode(item) else {
      return nil
    }
    
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.delete.description
    request.setValue(HttpMethod.createJsonContentType(), forHTTPHeaderField: HttpMethod.contentType)
    return request
  }
  
  func createPostRequest(with item: CreateItem) -> URLRequest? {
    guard let url = OpenMarketAPI.postProduct.url else {
      return nil
    }
    
    let data = createMultiPartBody(with: item)
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.post.description
    request.setValue(HttpMethod.createMultipartContentType(boundary: Self.boundary), forHTTPHeaderField: HttpMethod.contentType)
    return request
  }
  
  func createPatchRequest(id: Int, with item: UpdateItem) -> URLRequest? {
    guard let url = OpenMarketAPI.patchProduct(id: id).url else {
      return nil
    }
    
    let data = createMultiPartBody(with: item)
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = data
    request.httpMethod = HttpMethod.patch.description
    request.setValue(HttpMethod.createMultipartContentType(boundary: Self.boundary), forHTTPHeaderField: HttpMethod.contentType)
    return request
  }
}
