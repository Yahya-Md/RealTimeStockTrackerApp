//
//  StocksListServiceTests.swift
//  RealTimeStockTrackerTests
//

import XCTest
import RealTimeStockTracker

final class StocksListServiceTests: XCTestCase {
    func test_getStocks_retrunError_onLoaderError() async {
        let (sut, loader) = makeSUT()
        let expectedError = anyError()
        loader.expectedError = expectedError
        do {
            let _ = try await sut.getStocks()
            XCTFail("Should throw error")
        } catch(let error) {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    
    func test_getStocks_retrunsEmpty_onLoaderSuccess() async {
        let (sut, loader) = makeSUT()
        loader.data = anyEmptyStocks()
        do {
            let stocks = try await sut.getStocks()
            XCTAssertEqual(stocks.count, 0)
        } catch(_) {
            XCTFail("Should get User Data")
        }
    }
    
    func test_getStocks_retrunStocks_onLoaderSuccess() async {
        let (sut, loader) = makeSUT()
        let expectedStockes = anyStocks()
        loader.data = expectedStockes
        do {
            let stocks = try await sut.getStocks()
            XCTAssertEqual(stocks.count, expectedStockes.count)
        } catch(_) {
            XCTFail("Should get User Data")
        }
    }
}

extension StocksListServiceTests {
    func makeSUT() -> (sut: StocksListServiceImpl,loader: JsonLoadableMock) {
        let loader = JsonLoadableMock()
        let sut = StocksListServiceImpl(loader: loader)
        return (sut, loader)
    }
    
    // MARK: Error
    private func anyError() -> NSError {
        return NSError(domain: "", code: 0)
    }
    
    private func anyEmptyStocks() -> StocksListService.Stocks {
        return []
    }
    private func anyStocks() -> StocksListService.Stocks {
        return [StockResponse(symbol: "", companyName: "", stockDescription: "", basePrice: 10)]
    }
}

class JsonLoadableMock: JsonLoadable {
    var expectedError: Error?
    var data: Decodable?
    func fetch<T: Decodable>(for name: String) async throws -> T {
        if let data = self.data as? T {
            return data
        } else {
            throw expectedError ?? NSError()
        }
    }
}
