//
//  MockURLSession.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/17.
//
import XCTest
import Foundation
@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
  var makeRequestFail = false
  init(makeRequestFail: Bool = false) {
    self.makeRequestFail = makeRequestFail
  }
  
  var sessionDataTask: MockURLSessionDataTask?
  
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let url: URL = URL(string: MarketAPI.baseURL)!
    
    let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
    let failureResponse = HTTPURLResponse(url: url, statusCode: 410, httpVersion: "2", headerFields: nil)
    let sessionDataTask = MockURLSessionDataTask()
    
    sessionDataTask.resumeDidCall = {
      if self.makeRequestFail {
        completionHandler(nil, failureResponse, nil)
      } else {
        completionHandler(NSDataAsset(name: "Item")?.data, successResponse, nil)
      }
    }
    self.sessionDataTask = sessionDataTask
    return sessionDataTask
  }
}
