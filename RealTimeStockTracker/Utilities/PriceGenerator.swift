//
//  PriceGenerator.swift
//  RealTimeStockTracker
//

import Foundation

protocol PriceGenerator {
    func generate<T: Encodable>() -> T
}
