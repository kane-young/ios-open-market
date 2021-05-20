//
//  MockURLSessionDataTask.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/17.
//

import Foundation
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTask {
  var resumeDidCall: () -> Void = { }
  
  override func resume() {
    resumeDidCall()
  }
}
