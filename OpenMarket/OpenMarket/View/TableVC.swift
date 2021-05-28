//
//  TableVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

class TableVC: UIViewController {
  static let cellIdentifier = "TableCell"
  
  let listViewModel = ListViewModel()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension TableVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listViewModel.numOfList
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell =
            tableView.dequeueReusableCell(withIdentifier: TableVC.cellIdentifier,
                                          for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }
    
    let listInfo = listViewModel.itemInfo(at: indexPath.row)
    cell.update(info: listInfo)
    cell.backgroundColor = .lightGray
    
    return cell
  }
}
