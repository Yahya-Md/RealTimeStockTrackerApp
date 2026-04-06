//
//  Stock.swift
//  RealTimeStockTracker
//

struct Stock: Identifiable, Equatable{
    let id: Int
    let symbol: String
    let companyName: String
    let stockDescription: String
    var currentPrice: Double
}
