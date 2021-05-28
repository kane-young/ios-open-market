//
//  ListViewModel.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/27.
//

import UIKit

class ListViewModel {
  private var list: [ListItem] = []
  
  var numOfList: Int {
    return list.count
  }

  func listItemInfo(at index: Int) -> ListItem {
    return list[index]
  }
  
  func update(model: [ListItem]) {
    list = model
  }
}
