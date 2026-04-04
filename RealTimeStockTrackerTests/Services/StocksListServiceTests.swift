//
//  StocksListServiceTests.swift
//  RealTimeStockTrackerTests
//
//  Created by Renault on 1/4/2026.
//

import XCTest
import RealTimeStockTracker

final class StocksListServiceTests: XCTestCase {
    func test_getStocks_retrunError_onLoaderError() async {
        let (sut, loader) = makeSUT()
        let expectedError = NSError(domain: "", code: 0)
        loader.expectedError = expectedError
        do {
            let _ = try await sut.getStocks()
            XCTFail("Should throw error")
        } catch(let error) {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
}

extension StocksListServiceTests {
    func makeSUT() -> (sut: StocksListServiceImpl,loader: JsonLoadableMock) {
        let loader = JsonLoadableMock()
        let sut = StocksListServiceImpl(loader: loader)
        return (sut, loader)
    }
}

class JsonLoadableMock: JsonLoadable {
    var expectedError: Error?
    func fetch<T>(for name: String) async throws -> T where T : Decodable {
        throw expectedError ?? NSError()
    }
}
