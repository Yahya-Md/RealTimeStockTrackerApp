//
//  Stock.swift
//  RealTimeStockTracker
//

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
}
