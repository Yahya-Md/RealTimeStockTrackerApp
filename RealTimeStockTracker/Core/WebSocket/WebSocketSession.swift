//
//  WebSocketSession.swift
//  RealTimeStockTracker
//

import Foundation


protocol WebSocketSessionProtocol {
    func start() -> AsyncStream<PriceUpdate>
    func stop()
}

class WebSocketSession: WebSocketSessionProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL
    private let session: URLSession
    
    init(url: URL, session: URLSession) {
        self.url = url
        self.session = session
    }
    
    func start() -> AsyncStream<PriceUpdate> {
        let (stream, continuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        return stream
    }

    func stop() {
        webSocketTask?.cancel()
    }

}
