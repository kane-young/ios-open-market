//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/27.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var stock: UILabel!
  
  func update(info: ListItem) {
    imgView.image = info.image
    title.text = info.title
    price.text = "\(info.price)"
    stock.text = "\(info.stock)"
  }
}
