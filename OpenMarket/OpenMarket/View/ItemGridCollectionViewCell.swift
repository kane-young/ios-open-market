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
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: ItemDiscountedPriceLabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        itemTitleLable.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLable.text = nil
        itemDiscountedPriceLabel.text = nil
        itemDiscountedPriceLabel.isHidden = false
        itemPriceLabel.text = nil
        stockLabel.text = nil
    }
    
    func configureCell(image: String, title: String, discountedPrice: Int?, currency: String, price: Int, stock: Int) {
        guard let imageURL = URL(string: image) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        itemImageView?.image = UIImage(data: imageData)
        itemTitleLable?.text = title
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
