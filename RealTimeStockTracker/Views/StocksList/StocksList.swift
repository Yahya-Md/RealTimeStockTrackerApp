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
        .task {
            await vm.loadStocks()
        }
    }
}

#Preview {
    StocksList()
}
