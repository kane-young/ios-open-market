//
//  ItemPriceLabel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/07/13.
//

import UIKit

class ItemPriceLabel: UILabel {
    var isDiscounted: Bool?
    
    init() {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
