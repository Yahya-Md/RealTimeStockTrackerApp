//
//  StockDetails.swift
//  RealTimeStockTracker
//
//  Created by Renault on 6/4/2026.
//

import SwiftUI

struct StockDetails: View {
    let symbol: String
    @Environment(StockListViewModel.self) private var viewModel
    
    private var stock: Stock? {
        viewModel.stocks.first { $0.symbol == symbol }
    }
    
    var body: some View {
        Group {
            if let stock {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        stockInfo(stock: stock)
                        Divider()
                        stockAbout(description: stock.stockDescription)
                    }
                    .padding()
                }
                .navigationTitle(stock.symbol)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView(
                    "Symbol Not Found",
                    systemImage: "exclamationmark.triangle"
                )
            }
        }
    }
    
    private func stockInfo(stock: Stock) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stock.companyName)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Text(stock.currentPrice, format: .currency(code: "USD"))
                .font(.system(size: 48, weight: .bold, design: .rounded).monospacedDigit())
            
            PriceChangeIndicator(stock: stock)
                .font(.body)
        }
    }
    
    private func stockAbout(description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }
}

#Preview {
    StockDetails(symbol: "SYM")
}
