//
//  ItemPriceLabel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/07/13.
//

import UIKit

class ItemDiscountedPriceLabel: UILabel {
    var isDiscounted: Bool?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textColor = UIColor.systemRed
    }
    
    func configureStrikeStyleText(_ text: String?) {
        guard let text = text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
}
