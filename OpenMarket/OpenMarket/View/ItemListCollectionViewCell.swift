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
  @IBOutlet private weak var itemDiscountedPriceLabel: UILabel!
  @IBOutlet private weak var itemPriceLabel: UILabel!
  @IBOutlet private weak var stockLabel: UILabel!
  
  private var itemId = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemTitleLabel.adjustsFontSizeToFitWidth = true
  }
  
  override func prepareForReuse() {
    self.itemImageView.image = UIImage(named: "loading")
    self.itemTitleLabel.text = nil
    self.itemDiscountedPriceLabel.isHidden = false
    self.itemDiscountedPriceLabel.text = nil
    self.itemPriceLabel.attributedText = nil
    self.stockLabel.text = nil
  }
  
  func configureCell(item: ItemList.Item, completion: @escaping ((UIImage) -> Void)) {
    itemId = item.id
    configureThumbnail(item, completion: completion)
    configurePriceLabel(item: item)
    stockLabel.text = checkStockCount(item.stock)
    itemTitleLabel.text = item.title
  }
  
  func cacheForReuse() -> UIImage {
    return itemImageView.image!
  }
  
  func configureCellWithoutImageView(item: ItemList.Item) {
    configurePriceLabel(item: item)
    stockLabel.text = checkStockCount(item.stock)
    itemTitleLabel.text = item.title
  }
  
  func configureImageView(image: UIImage) {
    itemImageView.image = image
  }
  
  private func configurePriceLabel(item: ItemList.Item) {
    guard let itemPrice = convertIntToPrice(item.currency, item.price) else { return }
    if let discountedPrice = item.discountedPrice {
      let attributedString = NSMutableAttributedString(string: itemPrice)
      attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                   value: NSUnderlineStyle.single.rawValue,
                                   range: NSMakeRange(0, attributedString.length))
      itemPriceLabel.textColor = UIColor.systemRed
      itemPriceLabel.attributedText = attributedString
      itemDiscountedPriceLabel.textColor = UIColor.systemGray
      itemDiscountedPriceLabel.isHidden = false
      itemDiscountedPriceLabel.text = convertIntToPrice(item.currency, discountedPrice)
    } else {
      itemDiscountedPriceLabel.isHidden = true
      itemPriceLabel.textColor = UIColor.systemGray
      itemPriceLabel.text = itemPrice
    }
  }
  
  private func convertIntToPrice(_ currency: String, _ number: Int) -> String? {
    let formatter: NumberFormatter = NumberFormatter()
    formatter.numberStyle = .decimal
    guard let money = formatter.string(for: number) else {
      return nil
    }
    return currency + String.whiteSpace + money
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
  
  private func configureThumbnail(_ item: ItemList.Item, completion: @escaping ((UIImage) -> Void)) {
    guard let firstThumbnail = item.thumbnails.first,
          let url = URL(string: firstThumbnail) else { return }
    downloadImage(url: url) { [weak self] image in
      DispatchQueue.main.async {
        if self?.itemId == item.id {
          self?.itemImageView.image = image
        }
      }
      completion(image)
    }
  }
  
  private func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, let image = UIImage(data: data) else { return }
      completionHandler(image)
    }.resume()
  }
}
