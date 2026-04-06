//
//  Stock.swift
//  RealTimeStockTracker
//

import Foundation

enum PriceDirection: Equatable {
    case up
    case down
    case unchanged
}

struct Stock: Identifiable, Equatable{
    let id: Int
    let symbol: String
    let companyName: String
    let stockDescription: String
    var currentPrice: Double
    var previousPrice: Double
    
    var priceChange: Double {
        currentPrice - previousPrice
    }

    var priceChangePercent: Double {
        guard previousPrice > 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }

    var direction: PriceDirection {
        if priceChange > 0.001 { return .up }
        if priceChange < -0.001 { return .down }
        return .unchanged
    }
    
    init(
        symbol: String,
        companyName: String,
        stockDescription: String,
        basePrice: Double
    ) {
        self.id = UUID().hashValue
        self.symbol = symbol
        self.companyName = companyName
        self.stockDescription = stockDescription
        self.currentPrice = basePrice
        self.previousPrice = basePrice
    }
}
