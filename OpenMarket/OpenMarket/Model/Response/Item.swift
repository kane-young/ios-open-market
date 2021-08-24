//
//  ProductSearchResponse.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

struct Item: Decodable {
  let id: Int
  let title: String
  let descriptions: String
  let price: Int
  let currency: String
  let stock: Int
  let discountedPrice: Int?
  let thumbnails: [String]
  let images: [Data]
  let registrationDate: Double
  
  private enum CodingKeys: String, CodingKey {
    case id, title, descriptions, price, currency, stock, thumbnails, images
    case discountedPrice = "discounted_price"
    case registrationDate = "registration_date"
  }
}
