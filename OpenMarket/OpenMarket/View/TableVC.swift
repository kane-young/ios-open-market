//
//  TableVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

class TableVC: UIViewController {
}

extension TableVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
