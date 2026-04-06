//
//  StocksWebSocketService.swift
//  RealTimeStockTracker
//

import Foundation

protocol StocksWebSocket {
    func start() -> AsyncStream<PriceUpdate>
    func stop()
}

final class StocksWebSocketService: StocksWebSocket {
    
    enum Error: Swift.Error {
        case enableToDecode
    }
    
    let webSocket: WebSocketSessionProtocol
    
    init(webSocket: WebSocketSessionProtocol) {
        self.webSocket = webSocket
    }
    
    func start() -> AsyncStream<PriceUpdate> {
        AsyncStream { continuation in
            Task {
                for await data in webSocket.start() {
                    do {
                        let priceUpdate = try StocksWebSocketService.map(data)
                        continuation.yield(priceUpdate)
                    } catch {
                        debugPrint(
                            "Failed to decode data: \(error). Skipping this entry."
                        )
                    }
                }
                continuation.finish()
            }
        }
    }
    
    private static func map(_ data: Data) throws -> PriceUpdate {
        guard let prices = try? JSONDecoder().decode(PriceUpdate.self, from: data) else {
            throw Error.enableToDecode
        }
        return prices
    }
    
    func stop() {
        webSocket.stop()
    }
    
}
