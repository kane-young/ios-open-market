//
//  SegmentedVC.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/26.
//

import UIKit

enum ViewModeType: Int {
  case LIST = 0
  case GRID = 1
}

class SegmentedVC: UIViewController {
  // MARK:- View Life Cycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK:- Outlets
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  // MARK:- Variables
  
  // dummy
  private let list: [ListItem] = [
    ListItem(imageURL: "test", title: "test title1", price: 12345, stock: 678),
    ListItem(imageURL: "test", title: "test title2", price: 111, stock: 222),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0),
    ListItem(imageURL: "test", title: "test0", price: 0, stock: 0)
  ]
  
  private var tableViewController: TableVC {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(
      withIdentifier: "TableVC") as! TableVC
    self.add(asChildViewController: viewController)
    
    return viewController
  }
  
  private var collectionViewController: CollectionVC {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(
      withIdentifier: "CollectionVC") as! CollectionVC
    self.add(asChildViewController: viewController)
    
    return viewController
  }
  
  // MARK:- Abstract Method
  
  static func viewController() -> SegmentedVC {
    return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(
      withIdentifier: "SegementedView") as! SegmentedVC
  }
  
  // MARK:- Action Methods
  
  @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
    updateView()
  }
  
  // MARK:- Custom Methods
  
  private func add(asChildViewController viewController: UIViewController) {
    addChild(viewController)
    containerView.addSubview(viewController.view)
    
    viewController.view.frame = containerView.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    viewController.didMove(toParent: self)
  }
  
  private func remove(asChildViewController viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
  
  private func updateView() {
    let viewMode = ViewModeType.init(rawValue: segmentedControl.selectedSegmentIndex)
    switch viewMode {
    case .LIST:
      remove(asChildViewController: collectionViewController)
      add(asChildViewController: tableViewController)
      
    case .GRID:
      remove(asChildViewController: tableViewController)
      add(asChildViewController: collectionViewController)
      
      collectionViewController.listViewModel.update(model: list)
    default:
      break
    }
  }
  
  func setupView() {
    updateView()
  }
}
