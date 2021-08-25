//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/07/13.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell {
  static let identifier: String = "ItemListCollectionViewCell"
  
  @IBOutlet private weak var itemImageView: UIImageView!
  @IBOutlet private weak var itemTitleLabel: UILabel!
  @IBOutlet private weak var itemDiscountedPriceLabel: ItemDiscountedPriceLabel!
  @IBOutlet private weak var itemPriceLabel: UILabel!
  @IBOutlet private weak var stockLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemTitleLabel.adjustsFontSizeToFitWidth = true
  }
  
  override func prepareForReuse() {
    self.itemImageView.image = nil
    self.itemTitleLabel.text = nil
    self.itemDiscountedPriceLabel.isHidden = false
    self.itemDiscountedPriceLabel.text = nil
    self.itemPriceLabel.text = nil
    self.stockLabel.text = nil
  }
  
  func configureCell(image: String, title: String, discountedPrice: Int?, currency: String, price: Int, stock: Int) {
    guard let imageURL = URL(string: image) else { return }
    guard let imageData = try? Data(contentsOf: imageURL) else { return }
    itemImageView?.image = UIImage(data: imageData)
    itemTitleLabel?.text = title
    if let discounted = discountedPrice {
      itemDiscountedPriceLabel?.configureStrikeStyleText(convertIntToDecimal(currency, discounted))
    } else {
      itemDiscountedPriceLabel?.isHidden = true
    }
    itemPriceLabel?.text = convertIntToDecimal(currency, price)
    stockLabel?.text = checkStockCount(stock)
  }
  
  private func convertIntToDecimal(_ currency: String, _ number: Int) -> String? {
    let formatter: NumberFormatter = NumberFormatter()
    formatter.numberStyle = .decimal
    guard let money = formatter.string(for: number) else { return nil }
    return currency + money
  }
  
  private func checkStockCount(_ stock: Int) -> String {
    if stock == .zero {
      stockLabel.textColor = .systemYellow
      return "품절"
    }
    stockLabel.textColor = .darkGray
    if stock > 1000 {
      return "잔여수량 : 여유"
    }
    return "잔여수량 : " + String(stock)
  }
  
  private func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, let imageData = UIImage(data: data) else {
        return
      }
      completionHandler(imageData)
    }
  }
}
