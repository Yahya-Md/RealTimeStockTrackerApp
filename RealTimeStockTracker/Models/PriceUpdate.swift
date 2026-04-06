//
//  PriceUpdate.swift
//  RealTimeStockTracker
//

nonisolated struct PriceUpdate: Codable, Equatable, Sendable {
    let symbol: String
    let price: Double
    let timestamp: Double
}
