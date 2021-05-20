//
//  상품등록request.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation


//Uploadable을 채택한 파일 = multipart-formdata 형식으로 request를 보낼 형태
protocol Uploadable {
  var parameters: [String: Any?] { get }
}

struct ProductRegisterRequest: Encodable {
  let title: String
  let description: String
  let price: Int
  let currency: String
  let stock: Int
  let discountedPrice: Int?
  let images: [Data]
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case title, description, price, currency, stock, images, password
    case discountedPrice = "discounted_price"
  }
}

extension ProductRegisterRequest: Uploadable {
  var parameters: [String: Any?] {
    ["title":title,
     "description":description,
     "price":price,
     "currency":currency,
     "stock":stock,
     "discounted_price":discountedPrice,
     "images":images,
     "paswword":password]
  }
}
