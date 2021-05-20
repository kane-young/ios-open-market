//
//  APIRequestType.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/18.
//

import Foundation

enum APIRequestType {
  case loadPage(page: Int)
  case loadProduct(id: Int)
  case postProduct
  case patchProduct(id: Int)
  case deleteProduct(id: Int)
  
  static let baseURL: String = "https://camp-open-market-2.herokuapp.com"
  private var urlPath: String {
    switch self {
    case .loadPage(let page):
      return "/items/\(page)"
    case .loadProduct(let id):
      return "/item/\(id)"
    case .postProduct:
      return "/item/"
    case .patchProduct(let id):
      return "/item/\(id)"
    case .deleteProduct(let id):
      return "/item/\(id)"
    }
  }
  
  var url: URL? {
      return URL(string: "\(APIRequestType.baseURL)\(urlPath)")
  }
}
