//
//  OpenMarketAPIProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import UIKit

class OpenMarketAPIProvider: MarketRequestable {
  let session: URLSession
  var isPaginating: Bool = false
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
            OpenMarketAPI.successStatusCode.contains(response.statusCode) else {
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
  
  func postProduct(item: CreateItem,
                   completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let request = createPostRequest(with: item) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: request) { result in
      switch result {
      case .success(let data):
        completionHandler(.success(data))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func updateProduct(id: Int, to item: UpdateItem,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let request = createPatchRequest(id: id, with: item) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: request) { result in
      switch result {
      case .success(let data):
        completionHandler(.success(data))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func deleteProduct(id: Int, with item: DeleteItem, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let request = createDeleteRequest(id: id, with: item) else {
      completionHandler(.failure(.invalidRequest))
      return
    }
    
    dataTask(with: request) { result in
      switch result {
      case .success(let data):
        completionHandler(.success(data))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func getProduct(id: Int,
                  completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.loadProduct(id: id).url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    let request = URLRequest(url: url)
    
    dataTask(with: request) { result in
      switch result {
      case .success(let data):
        completionHandler(.success(data))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func getProducts(pagination: Bool = false, page: Int,
                   completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.loadPage(page: page).url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    
    if pagination {
      isPaginating = true
    }
    
    let urlRequest = URLRequest(url: url)
    
    dataTask(with: urlRequest) { [weak self] result in
      switch result {
      case .success(let data):
        completionHandler(.success(data))
        if pagination {
          self?.isPaginating = false
        }
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, let imageData = UIImage(data: data) else {
        return
      }
      completionHandler(imageData)
    }
  }
}
