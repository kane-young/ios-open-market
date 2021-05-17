//
//  OpenMarketAPIProviderTests.swift
//  OpenMarketTest
//
//  Created by 이영우 on 2021/05/17.
//

import XCTest
@testable import OpenMarket


class OpenMarketAPIProviderTests: XCTestCase {

  var sut: MarketAPIProvider!
  
    override func setUpWithError() throws {
      sut = .init(session: MockURLSession())
    }

    override func tearDownWithError() throws {
      sut = nil
    }

  func test_GETItem() {
    let expectation = XCTestExpectation()
    let response = try? JSONDecoder().decode(ProductSearchResponse.self, from: NSDataAsset(name: "Item")!.data)
  
    sut.searchItem(id: 30, completionHandler: { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data.id, response?.id)
        XCTAssertEqual(data.price, response?.price)
      case .failure:
        XCTFail()
      }
      expectation.fulfill()
    })
    
    wait(for: [expectation], timeout: 5.0)
  }

}
