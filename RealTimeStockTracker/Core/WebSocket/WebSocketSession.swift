//
//  WebSocketSession.swift
//  RealTimeStockTracker
//

import Foundation


protocol WebSocketSessionProtocol {
    func start(generator: PriceGenerator) -> AsyncStream<Data>
    func stop()
}

final class WebSocketSession: WebSocketSessionProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    private var sendTask: Task<Void, Never>?
    private var receiveTask: Task<Void, Never>?
    private var continuation: AsyncStream<Data>.Continuation?
    
    private let url: URL
    private let session: URLSession
    private var generator: PriceGenerator?
    
    init(url: URL, session: URLSession) {
        self.url = url
        self.session = session
    }
    
    func start(generator: PriceGenerator) -> AsyncStream<Data> {
        let (stream, continuation) = AsyncStream.makeStream(of: Data.self)
        self.continuation = continuation
        self.generator = generator
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        sendUpdates()
        receiveUpdates()
        
        return stream
    }

    func stop() {
        receiveTask?.cancel()
        receiveTask = nil
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        continuation?.finish()
        continuation = nil
        sendTask?.cancel()
        sendTask = nil
    }

    private func sendUpdates() {
        sendTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self, let generator else { break }
                let update: PriceUpdate = generator.generate()
                guard let data = try? JSONEncoder().encode(update),
                      let json = String(data: data, encoding: .utf8) else { continue }
                try? await self.webSocketTask?.send(.string(json))
                try? await Task.sleep(for: .seconds(0.5))
            }
        }
    }
    
    
    private func receiveUpdates() {
        receiveTask = Task { [weak self] in
            while let self, let task = self.webSocketTask, !Task.isCancelled {
                do {
                    let message = try await task.receive()
                    handleMessage(message)
                } catch {
                    if !Task.isCancelled {
                        handleDisconnection()
                    }
                    break
                }
            }
        }
    }

    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        let data: Data?
        switch message {
        case .string(let text):
            data = text.data(using: .utf8)
        case .data(let d):
            data = d
        @unknown default:
            return
        }
        guard let data else { return }
        continuation?.yield(data)
    }

    private func handleDisconnection() {
        stop()
    }
}
