//
//  StockListViewModel.swift
//  RealTimeStockTracker
//

import Foundation

@Observable
@MainActor
final class StockListViewModel {
    private(set) var stocks = [Stock]()
    private(set) var error: Error?
    private let service: StocksListService
    
    init(service: StocksListService) {
        self.service = service
    }
    
    func loadStocks() async {
        do {
            let result = try await service.getStocks()
            stocks = result.map { $0.toEntity() }
        } catch (let err) {
            error = err
        }
    }
}
