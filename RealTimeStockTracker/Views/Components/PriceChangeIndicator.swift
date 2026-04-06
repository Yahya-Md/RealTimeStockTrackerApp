//
//  PriceChangeIndicator.swift
//  RealTimeStockTracker
//
//  Created by Renault on 6/4/2026.
//

import SwiftUI

struct PriceChangeIndicator: View {
    let stock: Stock

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: stock.direction.iconName)
            switch stock.direction {
            case .up, .down:
                Text(String(format: "%+.2f (%.2f%%)", stock.priceChange, abs(stock.priceChangePercent)))
            case .unchanged:
                Text("")
            }
            
        }
        .font(.caption)
        .foregroundStyle(stock.direction.color)
    }
}

#Preview {
    VStack {
        PriceChangeIndicator(
            stock: Stock(
                id: 1,
                symbol: "SYM",
                companyName: "NAME",
                stockDescription: "DESC",
                currentPrice: 12,
                previousPrice: 12
            )
        )
        PriceChangeIndicator(
            stock: Stock(
                id: 1,
                symbol: "SYM",
                companyName: "NAME",
                stockDescription: "DESC",
                currentPrice: 12,
                previousPrice: 11.5
            )
        )
        PriceChangeIndicator(
            stock: Stock(
                id: 1,
                symbol: "SYM",
                companyName: "NAME",
                stockDescription: "DESC",
                currentPrice: 9.8,
                previousPrice: 10
            )
        )
    }
}

extension PriceDirection {
    var iconName: String {
        switch self {
        case .up: "arrow.up.right"
        case .down: "arrow.down.right"
        case .unchanged: "minus"
        }
    }

    var color: Color {
        switch self {
        case .up: .green
        case .down: .red
        case .unchanged: .secondary
        }
    }
}
