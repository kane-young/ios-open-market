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
    @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!

    override func awakeFromNib() {
        
    }
    
    func configureCell(image: UIImage, title: String, discountedPrice: Int?, price: Int, stock: Int) {
        itemImageView.image = image
        itemTitleLable.text = title
        if let discounted = discountedPrice {
            itemDiscountedPriceLabel.text = convertIntToDecimal(discounted)
        }
        itemPriceLabel.text = convertIntToDecimal(price)
        stockLabel.text = checkStockCount(stock)
    }
    
    private func convertIntToDecimal(_ number: Int) -> String? {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: number)
    }
    
    private func checkStockCount(_ stock: Int) -> String {
        if stock == .zero {
            stockLabel.textColor = .systemYellow
            return "품절"
        }
        stockLabel.textColor = .darkGray
        return String(stock)
    }
}
