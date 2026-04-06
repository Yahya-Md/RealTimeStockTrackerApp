//
//  StocksList.swift
//  RealTimeStockTracker
//

import SwiftUI

struct StocksList: View {
    @Environment(StockListViewModel.self) private var viewModel
    var body: some View {
        @Bindable var vm = viewModel
        
        List {
            ForEach(vm.stocks) { stock in
                NavigationLink(value: stock.symbol) {
                    StockItem(stock: stock)
                }
            }
        }
        .navigationDestination(for: String.self) { symbol in
            StockDetails(symbol: symbol)
        }
        .task {
            await vm.loadStocks()
        }
    }
}
