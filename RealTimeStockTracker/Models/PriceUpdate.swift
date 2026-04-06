//
//  PriceUpdate.swift
//  RealTimeStockTracker
//

struct PriceUpdate: Codable, Equatable, Sendable {
    let symbol: String
    let price: Double
    let timestamp: Double
}
