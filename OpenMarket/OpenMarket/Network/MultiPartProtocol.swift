//
//  MultiPartProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation
///
///
///Multipart form으로 Body를 작성해줄 수 있는 func들
protocol MultiPartProtocol {
  
  //Multipart [Image]를 encode해서 수동으로 data에 넣어주기
  private func makeBodyForImage(parameter: String, images: [Data]) -> Data {
    var data = Data()
    var imageIndex = 1
    
    images.forEach { image in
      data.appendString("--\(URLRequestManager.boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image\(imageIndex).png\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
      imageIndex += 1
    }

    return data
  }
  
  //Multipart normal Data encode해서 수동으로 data에 넣어주기
  private func makeBodyForNormal(parameter: String, value: Any?) -> Data {
    var data = Data()
            
    data.appendString("--\(URLRequestManager.boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
    if let value = value as? Int{
      data.appendString(String(value))
    }
    data.appendString("\r\n")
    return data
  }
}
