//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketListViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layoutType: LayoutType = LayoutType.list
    private var openMarketAPIProvider: OpenMarketAPIProvider = OpenMarketAPIProvider()
    private var nextPageToLoad: Int = 1
    private var openMarketItems: [ItemList.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        configureCollectionView()
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
    }
    
    private func fetchOpenMarketItems() {
        openMarketAPIProvider.getData(apiRequestType: .loadPage(page: 1), completionHandler: { [weak self] result in
            switch result {
            case .success(let items):
                self?.openMarketItems.append(items)
            }
        })
    }
    
    @objc func segmentedControlChangedValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            layoutType = .list
            
        case 1:
            layoutType = .grid
            
        default:
            break
        }
    }
}

extension OpenMarketListViewController: UICollectionViewDelegate {
    
}

extension OpenMarketListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return openMarketItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch layoutType {
//        case .list:
//
//        case .grid:
//
//        }
        return UICollectionViewCell()
    }
}

extension OpenMarketListViewController: UICollectionViewDelegateFlowLayout {
    
}

enum LayoutType {
    case list
    case grid
}
