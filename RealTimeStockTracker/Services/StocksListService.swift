//
//  StocksListService.swift
//  RealTimeStockTracker
//

public struct StockResponse: Decodable {
    let symbol: String
    let companyName: String
    let stockDescription: String
    let basePrice: Double
    
    public init(
        symbol: String,
        companyName: String,
        stockDescription: String,
        basePrice: Double
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.stockDescription = stockDescription
        self.basePrice = basePrice
    }
}

public protocol StocksListService {
    typealias Stocks = [StockResponse]
    func getStocks() async throws -> Stocks
}

public class StocksListServiceImpl: StocksListService {
    private let loader: JsonLoadable
    
    public init(loader: JsonLoadable) {
        self.loader = loader
    }
    
    public nonisolated func getStocks() async throws -> Stocks {
        return try await loader.fetch(for: "stocks")
    }
}
