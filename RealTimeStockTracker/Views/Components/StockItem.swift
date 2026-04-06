//
//  StockItem.swift
//  RealTimeStockTracker
//
//  Created by Renault on 6/4/2026.
//

import SwiftUI

struct StockItem: View {
    let stock: Stock
    var body: some View {
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

#Preview {
    StockItem(
        stock: Stock(id: 1, symbol: "SYM", companyName: "NAME", stockDescription: "DESC", currentPrice: 20)
    )
}
