//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

enum OpenMarketError: Error, CustomStringConvertible {
  case decodingProblem
  case encodingProblem
  case invalidURL
  case connectionProblem
  case invalidData
  case invalidRequest
  
  var description: String {
    switch self {
    case .decodingProblem:
      return "Decoding에 실패했습니다"
    case .encodingProblem:
      return "Encoding에 실패했습니다"
    case .invalidURL:
      return "유효하지 않는 URL입니다"
    case .connectionProblem:
      return "연결에 실패했습니다"
    case .invalidData:
      return "유효하지 않은 데이터입니다"
    case .invalidRequest:
      return "유효하지 않은 요청입니다"
    }
  }
}
