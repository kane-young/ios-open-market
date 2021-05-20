//
//  ItemSearcherProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

final class APIProvider {
  let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func load(urlRequest: URLRequest, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    session.dataTask(with: urlRequest, completionHandler: { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      if let data = data {
        completionHandler(.success(data))
        return
      }
      completionHandler(.failure(.invalidData))
    }).resume()
  }
}
