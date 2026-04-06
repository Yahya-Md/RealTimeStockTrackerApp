//
//  ContentView.swift
//  RealTimeStockTracker
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = StockListViewModel(
        service: StocksListServiceImpl(loader: JsonLoader(bundle: .main))
    )
    var body: some View {
        NavigationStack {
            StocksList()
        }
        .environment(viewModel)
    }
}

#Preview {
    ContentView()
}
