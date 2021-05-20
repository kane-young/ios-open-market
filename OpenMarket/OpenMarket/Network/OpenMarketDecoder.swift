//
//  OpenMarketDecoder.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

struct OpenMarketDecoder<T: Decodable> {
  func decode(requestType: RequestType, completionHandler: @escaping (Result<T, OpenMarketError>) -> ()) {
    do {
      let urlRequest = try URLRequestManager.makeURLRequest(httpMethod: .get, apiRequestType: requestType)
      
      OpenMarketAPIProvider().dataTask(with: urlRequest, completionHandler: { result in
        switch result {
        case .success(let data):
          do{
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completionHandler(.success(decodedData))
          } catch {
            completionHandler(.failure(.decodingProblem))
          }
        case .failure(let error):
          completionHandler(.failure(error))
        }
      })
    } catch {
      completionHandler(.failure(.invalidRequest))
    }
  }
}

