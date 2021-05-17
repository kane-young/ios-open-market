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
//final class ItemSearcher: ItemSearcherProtocol {
//  func search(id: Int, completionHandler: @escaping (ProductSearchResponse?) -> ()) {
//    let url = "https://camp-open-market-2.herokuapp.com/item/\(id)"
//    guard let requestURL: URL = URL(string: url) else { return }
//    var request = URLRequest(url: requestURL)
//    request.httpMethod = "GET"
//
//    let urlSession = URLSession.shared
//
//    urlSession.dataTask(with: request) { (data, response, error) in
//      guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == 200 else {
//        completionHandler(nil)
//        print(OpenMarketError.invalidSearchResult)
//        return
//      }
//
//      guard let data = data, error == nil else {
//        completionHandler(nil)
//        return
//      }
//
//      do {
//        let urlResponse = try JSONDecoder().decode(ProductSearchResponse.self, from: data)
//        completionHandler(urlResponse)
//      } catch {
//        print(OpenMarketError.invalidSearchResult)
//      }
//    }.resume()
//  }
//}
