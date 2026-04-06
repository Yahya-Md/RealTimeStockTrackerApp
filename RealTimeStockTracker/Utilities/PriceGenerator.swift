//
//  PriceGenerator.swift
//  RealTimeStockTracker
//

import Foundation

protocol PriceGenerator {
    func generate<T: Encodable>() -> T
}

final class RandomPriceGenerator: PriceGenerator {
    private var currentPrices: [String: Double]
    private let symbols: [String]

    // MARK: - Initializer

    nonisolated init(basePrices: [String: Double]) {
        self.currentPrices = basePrices
        self.symbols = Array(basePrices.keys)
    }

    // MARK: - Price Generation

    func generate<T: Encodable>() -> T {
        let symbol = symbols.randomElement()!
        let currentPrice = currentPrices[symbol, default: 100.0]
        let changePercent = Double.random(in: -0.02...0.02)
        let newPrice = max(0.01, currentPrice * (1 + changePercent))
        let roundedPrice = (newPrice * 100).rounded() / 100
        currentPrices[symbol] = roundedPrice
        return PriceUpdate(
            symbol: symbol,
            price: roundedPrice,
            timestamp: Date().timeIntervalSince1970
        ) as! T
    }
}
