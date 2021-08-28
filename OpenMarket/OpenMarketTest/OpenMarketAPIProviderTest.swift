//
//  OpenMarketAPIProviderTest.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class OpenMarketAPIProviderTest: XCTestCase {
  private var openMarketProvider: OpenMarketAPIProvider!
  private var expectation: XCTestExpectation!
  private let dummyItemCreate: OpenMarket.ItemCreate = OpenMarket.ItemCreate(title: "아이템",descriptions: "설명", price: 1000,currency: "KRW", stock: 100, discountedPrice: 400,images: [Data()], password: "123")
  private let dummyItemUpdate: OpenMarket.ItemUpdate = OpenMarket.ItemUpdate(title: "아이템", descriptions: "설명", price: 1000, currency: "KRW", stock: 100, discountedPrice: 400, images: [Data()], password: "123")
  private let dummyItemDelete: OpenMarket.ItemDelete = OpenMarket.ItemDelete(password: "123")
  
  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLSession.self]
    let urlSession = URLSession(configuration: configuration)
    openMarketProvider = OpenMarketAPIProvider(session: urlSession)
    expectation = XCTestExpectation()
  }
  
  override func tearDownWithError() throws {
    openMarketProvider = nil
    expectation = nil
  }

  func test_when_아이템생성시_then_error_notNil_connectionProblem에러발생() {
    //given
    guard let dummyURL: URL = URL(string: "www.google.com") else {
      XCTFail()
      return
    }
    MockURLSession.requestHandler = { _ in
      let response = HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
      return (response, Data(), OpenMarketError.connectionProblem)
    }
    //when
    openMarketProvider.postProduct(item: dummyItemCreate) { [weak self] result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(let error):
        //then
        XCTAssertEqual(error, .connectionProblem)
        self?.expectation.fulfill()
      }
    }
    wait(for: [expectation], timeout: 2.0)
  }

  func test_when_아이템수정시_statusCode가200번대가아닐경우_then_invalidResponse에러발생() {
    //given
    guard let dummyURL: URL = URL(string: "www.google.com") else {
      XCTFail()
      return
    }
    MockURLSession.requestHandler = { _ in
      let response = HTTPURLResponse(url: dummyURL, statusCode: 400, httpVersion: nil, headerFields: nil)
      return (response, Data(), nil)
    }
    //when
    openMarketProvider.updateProduct(id: 12, to: dummyItemUpdate) { [weak self] result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(let error):
        //then
        XCTAssertEqual(error, .invalidResponse)
        self?.expectation.fulfill()
      }
    }
    wait(for: [expectation], timeout: 2.0)
  }
  
  func test_when_아이템삭제시_data가nil일경우_then_invalidData에러발생() {
    //given
    guard let dummyURL: URL = URL(string: "www.google.com") else {
      XCTFail()
      return
    }
    MockURLSession.requestHandler = { _ in
      let response = HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
      return (response, nil, nil)
    }
    //when
    openMarketProvider.deleteProduct(id: 10, with: dummyItemDelete) { [weak self] result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(let error):
        //then
        XCTAssertEqual(error, OpenMarketError.invalidData)
        self?.expectation.fulfill()
      }
    }
    wait(for: [expectation], timeout: 2.0)
  }

  func test_when_아이템생성성공_then_data반환() {
    //given
    guard let dummyURL: URL = URL(string: "www.google.com") else {
      XCTFail()
      return
    }
    guard let mockData = try? JSONEncoder().encode(dummyItemCreate) else {
      XCTFail()
      return
    }
    MockURLSession.requestHandler = { _ in
      let response = HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
      return (response, mockData, nil)
    }
    //when
    openMarketProvider.postProduct(item: dummyItemCreate) { [weak self] result in
      switch result {
      case .success(let data):
        //then
        XCTAssertEqual(data, mockData)
        self?.expectation.fulfill()
      case .failure(_):
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 2.0)
  }
}
