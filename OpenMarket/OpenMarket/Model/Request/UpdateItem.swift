//
//  ProductUpdateRequest.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/13.
//

import Foundation

struct UpdateItem: Encodable {
  let title: String?
  let descriptions: String?
  let price: Int?
  let currency: String?
  let stock: Int?
  let discountedPrice: Int?
  let images: [Data]?
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case title, descriptions, price, currency, stock, images, password
    case discountedPrice = "discounted_price"
  }
}
