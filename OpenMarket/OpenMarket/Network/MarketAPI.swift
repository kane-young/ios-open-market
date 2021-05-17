//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/17.
//

import Foundation

enum MarketAPI {
  static let baseURL = "https://camp-open-market-2.herokuapp.com"
}

enum MarketAPIPath: CustomStringConvertible {
  case items
  case registrate
  case item
  case edit
  case delete
  
  var description: String {
      switch self {
      case .items:
          return "/items/"
      case .registrate:
          return "/item"
      case .item:
          return "/item/"
      case .edit:
          return "/item/"
      case .delete:
          return "/item/"
      }
  }
}
