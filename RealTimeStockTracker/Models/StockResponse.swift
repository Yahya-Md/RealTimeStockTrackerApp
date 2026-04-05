//
//  StockResponse.swift
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
