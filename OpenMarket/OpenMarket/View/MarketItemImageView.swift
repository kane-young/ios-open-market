//
//  MarketItemImageView.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/08/27.
//

import UIKit

class MarketItemImageView: UIImageView {
  func loadImage(with item: ItemList.Item) {
    guard let firstThumbnail = item.thumbnails.first,
          let url = URL(string: firstThumbnail) else { return }
    downloadImage(url: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.image = image
      }
    }
  }
  
  private func downloadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, let image = UIImage(data: data) else { return }
      completionHandler(image)
    }.resume()
  }
}
