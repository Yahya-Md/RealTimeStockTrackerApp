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
    private var sendTask: Task<Void, Never>?
    private var receiveTask: Task<Void, Never>?
    private var continuation: AsyncStream<PriceUpdate>.Continuation?
    
    private let url: URL
    private let session: URLSession
    private let generator: PriceGenerator
    
    init(url: URL, session: URLSession, generator: PriceGenerator) {
        self.url = url
        self.session = session
        self.generator = generator
    }
    
    func start() -> AsyncStream<PriceUpdate> {
        let (stream, continuation) = AsyncStream.makeStream(of: PriceUpdate.self)
        self.continuation = continuation
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        sendUpdates()
        receiveUpdates()
        
        return stream
    }

    func stop() {
        sendTask?.cancel()
        sendTask = nil
        receiveTask?.cancel()
        receiveTask = nil
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        continuation?.finish()
        continuation = nil
    }

    private func sendUpdates() {
        sendTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { break }
                let update: PriceUpdate = generator.generate()
                guard let data = try? JSONEncoder().encode(update) else { continue }
                try? await self.webSocketTask?.send(.data(data))
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
        guard let data,
              let update = try? JSONDecoder().decode(PriceUpdate.self, from: data) else { return }
        continuation?.yield(update)
    }

    private func handleDisconnection() {
        continuation?.finish()
        continuation = nil
    }
}
