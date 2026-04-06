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
            Section {
                Picker("Sort by", selection: $vm.sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            ForEach(vm.sortedStocks) { stock in
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                ConnectionStatusView(status: viewModel.connectionStatus)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleConnection()
                } label: {
                    Text(viewModel.connectionStatus == .connected ? "Stop" : "Start")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
