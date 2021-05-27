//
//  CollectionVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

class CollectionVC: UIViewController {
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell",
                                                  for: indexPath)
    
    return cell
  }
}
