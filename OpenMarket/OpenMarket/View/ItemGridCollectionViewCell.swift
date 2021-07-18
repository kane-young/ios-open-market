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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLable.text = nil
        itemDiscountedPriceLabel.text = nil
        itemPriceLabel.text = nil
        stockLabel.text = nil
    }

    func configureCell(image: UIImage, title: String, discountedPrice: Int?, currency: String, price: Int, stock: Int) {
        itemImageView.image = image
        itemTitleLable.text = title
        if let discounted = discountedPrice {
            itemDiscountedPriceLabel.configureStrikeStyleText(convertIntToDecimal(currency, discounted))
        } else {
            itemDiscountedPriceLabel.isHidden = true
        }
        itemPriceLabel.text = convertIntToDecimal(currency, price)
        stockLabel.text = checkStockCount(stock)
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
}
