//
//  CollectionVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

class CollectionVC: UIViewController {
  let listViewModel = ListViewModel()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return listViewModel.numOfList
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell",
                                               for: indexPath) as? CollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let listInfo = listViewModel.listItemInfo(at: indexPath.row)
    cell.update(info: listInfo)
    cell.backgroundColor = .lightGray
    
    return cell
  }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
  // 위 아래 간격
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  // 옆 간격
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  // cell 사이즈( 옆 라인을 고려하여 설정 )
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = collectionView.frame.width / 2 - 1 ///  2등분하여 배치, 옆 간격이 1이므로 1을 빼줌
    print("collectionView width=\(collectionView.frame.width)")
    print("cell하나당 width=\(width)")
    print("root view width = \(self.view.frame.width)")
    
    let size = CGSize(width: width, height: width)
    return size
  }
}
