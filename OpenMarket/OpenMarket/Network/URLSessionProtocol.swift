//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
