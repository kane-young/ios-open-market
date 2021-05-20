//
//  URLRequestManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation


//Body를 조립하고 , Request를 생성해줄 수 있는 func
protocol URLRequestProtocol: MultiPartProtocol {
  static var boundary: String { get }
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) throws -> URLRequest
  func makeHttpBody(product: MultiPartProtocol) -> Data {
  func encode(data: ProductDeleteRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ())
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
  
  // Multipart form 에 대한 Body 생성
  private func makeHttpBody(product: MultiPartProtocol) -> Data {
    var data: Data = Data()
    
    product.parameters.forEach { key, value in
      if let images = value as? [Data] {
        data.append(makeBodyForImage(parameter: key, images: images))
      } else if let value = value {
        data.append(makeBodyForNormal(parameter: key, value: value))
      }
    }
    
    data.appendString("--\(URLRequestManager.boundary)--\r\n")
    return data
  }
  
  // Json파일 형태에 대해 Encode 하고 Body 생성
  private func encode(data: ProductDeleteRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    do {
      let encodedData = try JSONEncoder().encode(data)
      completionHandler(.success(encodedData))
    } catch {
      completionHandler(.failure(.encodingProblem))
    }
  }
}
