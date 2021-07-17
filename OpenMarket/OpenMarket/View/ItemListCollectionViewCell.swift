//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/07/13.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ItemListCollectionViewCell"

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: ItemDiscountedPriceLabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!

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
