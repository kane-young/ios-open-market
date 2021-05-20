//
//  OpenMarketAPIProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation


// 중요한 점: response로 나온 Data값을 decoding할 때 어떤 타입인지는 어떻게 알려줄까?? 인자값? completionHandler의 success 연관값으로?
// 만들어진 Request를 이용해서 post, get, patch, delete를 dataTask를 통해서 하는 것
struct OpenMarketAPIProvider: URLRequestProtocol {
  let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  private func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    session.dataTask(with: urlRequest, completionHandler: { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      guard let data = data else {
        completionHandler(.failure(.invalidData))
        return
      }
      
      completionHandler(.success(data))
    }).resume()
  }
  
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
  
  func get(product) -> () {
    
  }
}
