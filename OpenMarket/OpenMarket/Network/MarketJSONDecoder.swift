//
//  MarketJSONDecoder.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/19.
//

import Foundation

struct MarketJSONDecoder<T: Decodable> {
  //ToDo: - completionHandler (Result<T, OpenMarketError>) 을 통해서 에러 제거
//  func decode(apiRequestType: APIRequestType, completionHandler: @escaping (Result<T, OpenMarketError>) throws -> ()) {
//    guard let urlRequest = try URLRequestProvider.makeURLRequest(httpMethod: .get, apiRequestType: apiRequestType) else {
//      completionHandler(.failure(.invalidRequest))
//      return
//    }
//
//    APIProvider().load(urlRequest: urlRequest, completionHandler: { result in
//      switch result {
//      case .success(let data):
//        do{
//          let decodedData = try JSONDecoder().decode(T.self, from: data)
//          completionHandler(.success(decodedData))
//        } catch {
//          completionHandler(.failure(.decodingProblem))
//        }
//      case .failure(let error):
//        completionHandler(.failure(error))
//      }
//    })
//  }
}
