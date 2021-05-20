//
//  ItemSearcher.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

extension URLSession: URLSessionProtocol { }

class MarketAPIProvider {
  let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func searchItem(id: Int, completionHandler: @escaping (Result<ProductSearchResponse, Error>) -> Void) {
    var url: URL {
      URL(string: MarketAPI.baseURL + "item/\(id)")!
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task: URLSessionDataTask = session.dataTask(with: request) { data, urlResponse, error in
      guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
        completionHandler(.failure(error ?? OpenMarketError.invalidSearchResult))
        return
      }
      
      if let data = data, let productSearchResponse = try? JSONDecoder().decode(ProductSearchResponse.self, from: data) {
        completionHandler(.success(productSearchResponse))
        return
      }
      
      completionHandler(.failure(OpenMarketError.decodingProblem))
    }
    
    task.resume()
  }
}
