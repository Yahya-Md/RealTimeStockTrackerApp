//
//  StocksWebSocketServiceTests.swift
//  RealTimeStockTrackerTests
//

import XCTest
@testable import RealTimeStockTracker

final class StocksWebSocketServiceTests: XCTestCase {

    // MARK: - start()

    func test_start_deliversPriceUpdate_onValidData() async {
        let (sut, mock) = makeSUT()
        let expected = anyPriceUpdate()
        mock.dataToEmit = [encode(expected)]

        let stream = await sut.start()
        let received = await firstElement(from: stream)

        XCTAssertEqual(received, expected)
    }

    func test_start_deliversMultipleUpdates_onMultipleValidData() async {
        let (sut, mock) = makeSUT()
        let update1 = anyPriceUpdate(symbol: "AAPL", price: 150.0)
        let update2 = anyPriceUpdate(symbol: "GOOG", price: 2800.0)
        mock.dataToEmit = [encode(update1), encode(update2)]

        let stream = await sut.start()
        let received = await collect(from: stream, count: 2)

        XCTAssertEqual(received, [update1, update2])
    }

    func test_start_skipsInvalidData_andDeliversValidOnes() async {
        let (sut, mock) = makeSUT()
        let validUpdate = anyPriceUpdate()
        let invalidData = Data("not json".utf8)
        mock.dataToEmit = [invalidData, encode(validUpdate)]

        let stream = await sut.start()
        let received = await collect(from: stream, count: 1)

        XCTAssertEqual(received, [validUpdate])
    }

    func test_start_finishesStream_whenWebSocketEnds() async {
        let (sut, mock) = makeSUT()
        mock.dataToEmit = []

        let stream = await sut.start()
        let received = await collect(from: stream, count: 0)

        XCTAssertTrue(received.isEmpty)
    }
    
    func test_send_encodesAndForwardsToWebSocket() async throws {
        let (sut, mock) = makeSUT()
        let update = anyPriceUpdate()

        try await sut.send(update)

        XCTAssertEqual(mock.sentMessages.count, 1)
        let sentData = mock.sentMessages.first!.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(PriceUpdate.self, from: sentData)
        XCTAssertEqual(decoded, update)
    }
    
    func test_send_throwsOnWebSocketError() async {
        let (sut, mock) = makeSUT()
        let resultError = NSError(domain: "test", code: 1)
        mock.sendError = resultError

        do {
            try await sut.send(anyPriceUpdate())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, resultError)
        }
    }
    
    func test_stop_callsStopOnWebSocket() async {
        let (sut, mock) = makeSUT()

        await sut.stop()

        XCTAssertTrue(mock.stopCalled)
    }
}

// MARK: - Helpers

extension StocksWebSocketServiceTests {
    private func makeSUT() -> (sut: StocksWebSocketService, mock: WebSocketSessionMock) {
        let mock = WebSocketSessionMock()
        let sut = StocksWebSocketService(webSocket: mock)
        return (sut, mock)
    }

    private func anyPriceUpdate(
        symbol: String = "AAPL",
        price: Double = 150.0,
        timestamp: Double = 1000.0
    ) -> PriceUpdate {
        PriceUpdate(symbol: symbol, price: price, timestamp: timestamp)
    }

    private func encode(_ update: PriceUpdate) -> Data {
        try! JSONEncoder().encode(update)
    }

    private func firstElement(from stream: AsyncStream<PriceUpdate>) async -> PriceUpdate? {
        var iterator = stream.makeAsyncIterator()
        return await iterator.next()
    }

    private func collect(from stream: AsyncStream<PriceUpdate>, count: Int) async -> [PriceUpdate] {
        var results = [PriceUpdate]()
        for await element in stream {
            results.append(element)
            if results.count >= count && count > 0 { break }
        }
        return results
    }
}

final class WebSocketSessionMock: WebSocketSessionProtocol {
    var dataToEmit: [Data] = []
    var sentMessages: [String] = []
    var sendError: Error?
    var stopCalled = false

    func start() -> AsyncStream<Data> {
        let data = dataToEmit
        return AsyncStream { continuation in
            for item in data {
                continuation.yield(item)
            }
            continuation.finish()
        }
    }

    func send(_ data: String) async throws {
        if let error = sendError {
            throw error
        }
        sentMessages.append(data)
    }

    func stop() {
        stopCalled = true
    }
}
