//
//  CollectionVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var stock: UILabel!
}

class CollectionVC: UIViewController {
  // dummy
  let list = [1,2,3,4,5,6,7,8,9,10]
  let dummyName = ["MacBook Pro", "Mac mini", "test3", "test4" ,"test5", "test6", "test7", "test8", "test9", "test10"]
  let dummyPrice = ["USD 2,000", "KRW 2,000,000", "123", "123", "123", "123", "123", "123", "123", "123"]
  let dummyStock = ["잔여수량:148", "품절", "test", "test", "test", "test", "test", "test", "test", "test"]
  
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
    return list.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell",
                                                  for: indexPath) as! CollectionViewCell
    cell.backgroundColor = .lightGray
    cell.imageView.image = UIImage(named: "testImage.png")
    cell.title.text = dummyName[indexPath.row]
    cell.price.text = dummyPrice[indexPath.row]
    cell.stock.text = dummyStock[indexPath.row]

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
