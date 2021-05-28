//
//  ListItem.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/27.
//

import UIKit

struct ListItem {
  let imageURL: String
  let title: String
  let price: UInt
  let stock: UInt
  
  var image: UIImage {
    var resultImage = UIImage(named: "testImage.png")!
    let url = URL(string: imageURL)
//    URLSession.shared.dataTask(with: url!) { data, response, error in
//      let image = UIImage(data: data!)!
//      DispatchQueue.main.async {
//        resultImage = image
//      }
//    }.resume()
    
    return resultImage
  }
  
  init(imageURL: String,
       title: String,
       price: UInt,
       stock: UInt) {
    self.imageURL = imageURL
    self.title = title
    self.price = price
    self.stock = stock
  }
}
