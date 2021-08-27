//
//  MultiPartProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/25.
//

import Foundation

protocol MultiPartProtocol {
  static var boundary: String { get }
  func createMultiPartBody<T: Encodable>(with item: T) -> Data
}

extension MultiPartProtocol {
  func createMultiPartBody<T: Encodable>(with item: T) -> Data {
    var data: Data = Data()
    let mirror = Mirror(reflecting: item)

    mirror.children.forEach { key, value in
      guard let key = key else { return }
      if let images = value as? [Data] {
        data.append(convertMultiPartForm(imageName: key, images: images, boundary: Self.boundary))
      } else {
        data.append(convertMultiPartForm(name: key, value: value, boundary: Self.boundary))
      }
    }

    data.appendString("--\(Self.boundary)--\r\n")
    return data
  }

  private func convertMultiPartForm(imageName: String, images: [Data], boundary: String) -> Data {
    var data = Data()
    
    for image in images {
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(imageName)\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
    }
    
    return data
  }

  private func convertMultiPartForm(name: String, value: Any, boundary: String) -> Data {
    var data = Data()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
    data.appendString("\(value)\r\n")
    
    return data
  }
}
