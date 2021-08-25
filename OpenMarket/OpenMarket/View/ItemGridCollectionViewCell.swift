//
//  ItemGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/07/18.
//

import UIKit

class ItemGridCollectionViewCell: UICollectionViewCell {
  static let identifier: String = "ItemGridCollectionViewCell"
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
  @IBOutlet weak var itemPriceLabel: UILabel!
  @IBOutlet weak var stockLabel: UILabel!
  
  override func awakeFromNib() {
    self.contentView.layer.cornerRadius = 10
    self.contentView.layer.borderWidth = 1
    itemTitleLabel.adjustsFontSizeToFitWidth = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    itemImageView.image = nil
    itemTitleLabel.text = nil
    itemDiscountedPriceLabel.text = nil
    itemDiscountedPriceLabel.isHidden = false
    itemPriceLabel.text = nil
    stockLabel.text = nil
  }
  
  func configureCell(item: ItemList.Item) {
    configureThumbnail(item)
    configurePriceLabel(item: item)
    stockLabel.text = checkStockCount(item.stock)
    itemTitleLabel.text = item.title
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
  
  private func configureThumbnail(_ item: ItemList.Item) {
    guard let firstThumbnail = item.thumbnails.first,
          let url = URL(string: firstThumbnail) else { return }
    downloadImage(url: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.itemImageView.image = image
      }
    }
  }
  
  private func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, let image = UIImage(data: data) else { return }
      completionHandler(image)
    }.resume()
  }
}
