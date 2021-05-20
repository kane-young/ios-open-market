//
//  HttpBodyProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

struct URLRequestManager: URLRequestProtocol {
  
  func setPostBody(product: ProductRegisterRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    do {
      var urlRequest = try makeURLRequest(httpMethod: .post, apiRequestType: apiRequestType)
      urlRequest.httpBody = makeHttpBody(product: product)
      completionHandler(.success(urlRequest))
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
  }
  
  func setUpdateBody(product: ProductUpdateRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    do {
      var urlRequest = try makeURLRequest(httpMethod: .patch, apiRequestType: apiRequestType)
      urlRequest.httpBody = makeHttpBody(product: product)
      completionHandler(.success(urlRequest))
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
  }
  
  func setDeleteBody(product: ProductDeleteRequest, apiRequestType: RequestType, completionHandler: @escaping (Result<URLRequest, OpenMarketError>) -> ()) {
    do {
      var urlRequest = try makeURLRequest(httpMethod: .delete, apiRequestType: apiRequestType)
      
      encode(data: product, completionHandler: { result in
        switch result {
        case .success(let data):
          urlRequest.httpBody = data
          completionHandler(.success(urlRequest))
        case .failure:
          completionHandler(.failure(.encodingProblem))
        }
      })
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
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
    
    data.appendString("--\(HttpBodyProvider.boundary)--\r\n")
    return data
  }
  
  private func encode(data: ProductDeleteRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    do {
      let encodedData = try JSONEncoder().encode(data)
      completionHandler(.success(encodedData))
    } catch {
      completionHandler(.failure(.encodingProblem))
    }
  }
  
  private func makeBodyForImage(parameter: String, images: [Data]) -> Data {
    var data = Data()
    var imageIndex = 1
    
    images.forEach { image in
      data.appendString("--\(HttpBodyProvider.boundary)\r\n")
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
            
    data.appendString("--\(HttpBodyProvider.boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
    if let value = value as? Int{
      data.appendString(String(value))
    }
    data.appendString("\r\n")
    return data
  }
}
