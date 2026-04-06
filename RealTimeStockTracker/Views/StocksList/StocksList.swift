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
                    StockItem(stock: stock)
                }
            }
        }
    }
}

#Preview {
    StocksList()
}
