//
//  ItemSearcherProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
