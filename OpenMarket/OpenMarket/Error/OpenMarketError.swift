//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

enum OpenMarketError: Error {
  case connectionProblem
  case decodingProblem
  case invalidData
  case invalidURL
  case invalidRequest
  case encodingProblem
}
