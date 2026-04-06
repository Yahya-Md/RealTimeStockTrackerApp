//
//  StockListViewModel.swift
//  RealTimeStockTracker
//

import Foundation

enum SortOption: String, CaseIterable {
    case byPrice = "Price"
    case byPriceChange = "Change"
}

@Observable
@MainActor
final class StockListViewModel {
    private(set) var stocks = [Stock]()
    private(set) var error: Error?
    private(set) var connectionStatus: ConnectionStatus = .disconnected
    private var listeningTask: Task<Void, Never>?
    private let service: StocksListService
    private var webSocketService: StocksWebSocket
    var sortOption: SortOption = .byPrice
    
    init(
        service: StocksListService,
        socketService: StocksWebSocket
    ) {
        self.service = service
        self.webSocketService = socketService
    }
    
    var sortedStocks: [Stock] {
        switch sortOption {
        case .byPrice:
            stocks.sorted { $0.currentPrice > $1.currentPrice }
        case .byPriceChange:
            stocks.sorted { abs($0.priceChange) > abs($1.priceChange) }
        }
    }
    
    func loadStocks() async {
        do {
            let result = try await service.getStocks()
            stocks = result.map { $0.toEntity() }
        } catch (let err) {
            error = err
        }
    }
    
    private func startListening() {
        connectionStatus = .connected
        let generator = RandomPriceGenerator(
            basePrices: Dictionary(
                uniqueKeysWithValues: stocks.map { ($0.symbol, $0.currentPrice)
                }))
        let stream = webSocketService.start(generator: generator)
        listeningTask = Task {
            for await update in stream {
                guard !Task.isCancelled else { break }
                applyUpdate(update)
            }
            if connectionStatus == .connected {
                connectionStatus = .disconnected
            }
            
        }
    }
    
    private func applyUpdate(_ update: PriceUpdate) {
        guard let index = stocks.firstIndex(where: { $0.symbol == update.symbol }) else { return }
        stocks[index].previousPrice = stocks[index].currentPrice
        stocks[index].currentPrice = update.price
    }
    
    private func stopListening() {
        listeningTask?.cancel()
        listeningTask = nil
        webSocketService.stop()
        connectionStatus = .disconnected
    }
    
    func toggleConnection() {
        if connectionStatus == .connected {
            stopListening()
        } else {
            startListening()
        }
    }
}
