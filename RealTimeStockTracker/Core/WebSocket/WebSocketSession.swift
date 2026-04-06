//
//  WebSocketSession.swift
//  RealTimeStockTracker
//

import Foundation

protocol WebSocketSessionProtocol {
    func start() -> AsyncStream<Data>
    func send(_ data: String) async throws
    func stop()
}

final class WebSocketSession: WebSocketSessionProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    private var receiveTask: Task<Void, Never>?
    private var continuation: AsyncStream<Data>.Continuation?

    private let url: URL
    private let session: URLSession

    init(url: URL = URL(string: "wss://ws.postman-echo.com/raw")!,
         session: URLSession) {
        self.url = url
        self.session = session
    }

    func start() -> AsyncStream<Data> {
        let (stream, continuation) = AsyncStream.makeStream(of: Data.self)
        self.continuation = continuation
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()

        receiveUpdates()

        return stream
    }

    func send(_ data: String) async throws {
        try await webSocketTask?.send(.string(data))
    }

    func stop() {
        receiveTask?.cancel()
        receiveTask = nil
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        continuation?.finish()
        continuation = nil
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
