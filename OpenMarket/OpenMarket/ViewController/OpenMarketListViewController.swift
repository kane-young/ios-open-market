//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketListViewController: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var openMarketItems: [ItemList.Item] = []
  private var layoutType: LayoutType = .list
  private let openMarketApiProvider = OpenMarketAPIProvider()
  private var currentPage: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchProjectItems(page: currentPage)
    configureSegmentedControl()
    configureCollectionView()
  }
  
  private func fetchProjectItems(page: Int) {
    openMarketApiProvider.getProducts(page: page) { [weak self] result in
      switch result {
      case .success(let data):
        let decodedData = try? JSONDecoder().decode(ItemList.self
                                                    , from: data)
        if let data = decodedData {
          self?.openMarketItems.append(contentsOf: data.items)
        }
        
        DispatchQueue.main.async {
          self?.collectionView.reloadData()
        }
      case .failure:
        fatalError()
      }
    }
  }
  
  private func configureSegmentedControl() {
    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
    segmentedControl.selectedSegmentTintColor = .systemBlue
    segmentedControl.backgroundColor = .white
    segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(_:)), for: .valueChanged)
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: width, height: height)
    collectionView.collectionViewLayout = layout
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(UINib(nibName: ItemListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ItemListCollectionViewCell.identifier)
    collectionView.register(UINib(nibName: ItemGridCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ItemGridCollectionViewCell.identifier)
  }
  
  @objc func segmentedControlChangedValue(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      layoutType = .list
      collectionView.reloadData()
    case 1:
      layoutType = .grid
      collectionView.reloadData()
    default:
      return
    }
  }
}

extension OpenMarketListViewController: UICollectionViewDelegate {
  
}

extension OpenMarketListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return openMarketItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if openMarketItems.isEmpty == true {
      return UICollectionViewCell()
    }
    
    let item = openMarketItems[indexPath.item]
    switch layoutType {
    case .list:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCollectionViewCell.identifier, for: indexPath) as? ItemListCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.configureCell(item: item)
      return cell
    case .grid:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCollectionViewCell.identifier, for: indexPath) as? ItemGridCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.configureCell(item: item)
      return cell
    }
  }
}

extension OpenMarketListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch layoutType {
    case .list:
      let cellWidth = collectionView.frame.width
      let cellHeight = collectionView.frame.height / 10
      return CGSize(width: cellWidth, height: cellHeight)
    case .grid:
      let cellWidth = collectionView.frame.width / 2
      let cellHeight = collectionView.frame.height / 3
      return CGSize(width: cellWidth, height: cellHeight)
    }
  }
}

enum LayoutType {
  case list
  case grid
}

extension OpenMarketListViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = scrollView.contentOffset.y
    if (position > (scrollView.contentSize.height - 100 - scrollView.frame.size.height)) {
      fetchProjectItems(page: currentPage)
    }
  }
}