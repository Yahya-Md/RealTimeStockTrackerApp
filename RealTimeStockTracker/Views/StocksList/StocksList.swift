//
//  StocksList.swift
//  RealTimeStockTracker
//

import SwiftUI

struct StocksList: View {
    let list: [Stock] = [
        Stock(
            id: 1,
            symbol: "SYM",
            companyName: "NAME",
            stockDescription: "DESC",
            currentPrice: 10
        ),
        Stock(
            id: 2,
            symbol: "SYM",
            companyName: "NAME",
            stockDescription: "DESC",
            currentPrice: 10
        )
    ]
    var body: some View {
        List {
            ForEach(list) { stock in
                NavigationLink(value: stock.symbol) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stock.symbol)
                                .font(.headline)
                            Text(stock.companyName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(stock.currentPrice, format: .currency(code: "USD"))
                                .font(.body.monospacedDigit())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    StocksList()
}
