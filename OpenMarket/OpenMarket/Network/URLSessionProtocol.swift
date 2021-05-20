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

//삭제 대기 : URLSessionProtocol 버리고 URLProtocol을 활용해서 네트워크 과정을 가정하고 Test해보자
