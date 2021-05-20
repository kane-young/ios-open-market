//
//  HttpBodyProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

struct HttpBodyProvider {
  private let boundary = URLRequestManager.boundary
  
  func setPostBody(product: ProductRegisterRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    do {
      var urlRequest = try URLRequestManager.makeURLRequest(httpMethod: .post, apiRequestType: apiRequestType)
      urlRequest.httpBody = makeHttpBody(product: product)
      completionHandler(.success(urlRequest))
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
  }
  
  func setUpdateBody(product: ProductUpdateRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    do {
      var urlRequest = try URLRequestManager.makeURLRequest(httpMethod: .patch, apiRequestType: apiRequestType)
      urlRequest.httpBody = makeHttpBody(product: product)
      completionHandler(.success(urlRequest))
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
  }
  
  //강제 언래핑 제거 or URLRequestProvider throws 제거 && encode에 completionHandler 삽입
  func setDeleteBody(product: ProductDeleteRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    var urlRequest: URLRequest?
    var encodedData: Data = Data()
    
    do {
      urlRequest = try URLRequestManager.makeURLRequest(httpMethod: .delete, apiRequestType: apiRequestType)
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
    
//    do {
//      encodedData = try encode(data: product)
//      urlRequest!.httpBody = encodedData
//      completionHandler(.success(urlRequest!))
//    } catch {
//      completionHandler(.failure(.encodingProblem))
//    }
  }
  
  private func makeHttpBody(product: MultiPartProtocol) -> Data {
    var data: Data = Data()
    
    product.parameters.forEach { key, value in
      if let images = value as? [Data] {
        data.append(makeBodyForImage(parameter: key, images: images))
      } else if let value = value {
        data.append(makeBodyForNormal(parameter: key, value: value))
      }
    }
    
    data.appendString("--\(boundary)--\r\n")
    return data
  }
  
  private func encode(data: ProductDeleteRequest) throws -> Data {
    let encodedData = try JSONEncoder().encode(data)
    return encodedData
  }
  
  private func makeBodyForImage(parameter: String, images: [Data]) -> Data {
    var data = Data()
    var imageIndex = 1
    
    images.forEach { image in
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image\(imageIndex).png\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
      imageIndex += 1
    }

    return data
  }
  
  private func makeBodyForNormal(parameter: String, value: Any?) -> Data {
    var data = Data()
            
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
    if let value = value as? Int{
      data.appendString(String(value))
    }
    data.appendString("\r\n")
    return data
  }
}

extension Data {
  mutating func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}

