//
//  OpenMarketAPIProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

struct OpenMarketAPIProvider: JsonProtocol, MultiPartProtocol {
  let session: URLSession
  static var boundary: String = UUID().uuidString
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  private func dataTask(with urlRequest: URLRequest,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    session.dataTask(with: urlRequest, completionHandler: { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      guard let response = response as? HTTPURLResponse,
            RequestType.successStatusCode.contains(response.statusCode) else {
        completionHandler(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completionHandler(.failure(.invalidData))
        return
      }
      
      completionHandler(.success(data))
    }).resume()
  }
  
  func postProduct(product: CreateItem,
                   completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let urlRequest = setMultiPartBody(httpMethod: .post,
                                            apiRequestType: .postProduct,
                                            product: product) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: urlRequest) { data in
      completionHandler(data)
    }
  }

  func updateProduct(product: UpdateItem,
                     id: Int,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let urlRequest = setMultiPartBody(httpMethod: .patch,
                                            apiRequestType: .patchProduct(id: id),
                                            product: product) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: urlRequest) { data in
      completionHandler(data)
    }
  }
  
  func deleteProduct(product: DeleteItem,
                     id: Int,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let urlRequest = setJsonBody(httpMethod: .delete,
                                       apiRequestType: .deleteProduct(id: id),
                                       product: product) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: urlRequest) { data in
      completionHandler(data)
    }
  }

  func getData(id: Int,
               completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let urlRequest = makeURLRequest(httpMethod: .get,
                                          apiRequestType: .loadProduct(id: id)) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: urlRequest) { data in
      completionHandler(data)
    }
  }
    
    func getDatas(page: Int,
                  completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
        guard let urlRequest = makeURLRequest(httpMethod: .get,
                                              apiRequestType: .loadPage(page: page)) else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        
        dataTask(with: urlRequest) { data in
            completionHandler(data)
        }
    }
}
