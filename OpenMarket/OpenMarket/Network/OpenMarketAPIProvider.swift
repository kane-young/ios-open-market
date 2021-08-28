//
//  OpenMarketAPIProvider.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import UIKit

class OpenMarketAPIProvider: MarketRequestable {
  private let session: URLSession
  static var boundary: String = UUID().uuidString
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  private func dataTask(with urlRequest: URLRequest,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    session.dataTask(with: urlRequest, completionHandler: { data, response, error in
      if error != nil {
        completionHandler(.failure(.connectionProblem))
        return
      }
      
      guard let response = response as? HTTPURLResponse,
            OpenMarketAPI.successStatusCode.contains(response.statusCode) else {
        completionHandler(.failure(.invalidResponse))
        return
      }
      
      guard let data = data, data.isEmpty != true else {
        completionHandler(.failure(.invalidData))
        return
      }
      
      completionHandler(.success(data))
    }).resume()
  }
  
  func postProduct(item: ItemCreate,
                   completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.postProduct.url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    
    guard let request = createMultiPartFormRequest(url: url, .post, with: item) else {
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

  func updateProduct(id: Int, to item: ItemUpdate,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.patchProduct(id: id).url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    
    guard let request = createMultiPartFormRequest(url: url, .patch, with: item) else {
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

  func deleteProduct(id: Int, with item: ItemDelete, completionHandler: @escaping (Result<Data, OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.deleteProduct(id: id).url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    
    guard let request = createJsonFormRequest(url: url, .delete, with: item) else {
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

  func getProducts(page: Int,
                   completionHandler: @escaping (Result<[ItemList.Item], OpenMarketError>) -> ()) {
    guard let url = OpenMarketAPI.loadPage(page: page).url else {
      completionHandler(.failure(.invalidURL))
      return
    }
    let urlRequest = URLRequest(url: url)
    
    dataTask(with: urlRequest) { result in
      switch result {
      case .success(let data):
        let decodedData = try? JSONDecoder().decode(ItemList.self, from: data)
        if let itemList = decodedData {
          completionHandler(.success(itemList.items))
        }
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }

  func downloadImage(url: URL, completionHandler: @escaping (Result<UIImage, OpenMarketError>) -> Void) {
    dataTask(with: URLRequest(url: url)) { result in
      switch result {
      case .success(let data):
        guard let image = UIImage(data: data) else {
          return
        }
        completionHandler(.success(image))
        
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }
}
