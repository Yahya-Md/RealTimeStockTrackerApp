//
//  StockResponseList+Mapper.swift
//  RealTimeStockTracker
//

extension StockResponse {
    func toEntity() -> Stock {
        Stock(
            symbol: symbol,
            companyName: companyName,
            stockDescription: stockDescription,
            basePrice: basePrice,
        )
    }
}
