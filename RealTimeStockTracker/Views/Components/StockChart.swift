//
//  StockChart.swift
//  RealTimeStockTracker
//
//  Created by Renault on 6/4/2026.
//

import SwiftUI

struct StockChart: View {
    let prices: [Double]
    let color: Color
    let max: Double
    let min: Double
    
    private var currentPrice: Double { prices.last ?? 0 }
    private var currentNormalized: CGFloat {
        let range = max - min
        guard range > 0 else { return 0.5 }
        return 1 - CGFloat((currentPrice - min) / range)
    }
    
    init(prices: [Double], color: Color) {
        self.prices = prices
        self.max = prices.max() ?? 0
        self.min = prices.min() ?? 0
        self.color = color
    }
    
    var body: some View {
        
        GeometryReader { reader in
            ZStack {
                Path { path in
                    for index in prices.indices {
                        let xPos = reader.size.width / CGFloat(prices.count) * CGFloat(index + 1)
                        let yAxis = max - min
                        let yPos = yAxis > 0
                        ? (1 - CGFloat((prices[index] - min) / yAxis)) * reader.size.height
                        : reader.size.height / 2
                        if index == 0 {
                            path.move(to: CGPoint(x: 0, y: yPos))
                        }
                        path.addLine(to: CGPoint(x: xPos, y: yPos))
                    }
                }
                .stroke(lineWidth: 2)
                .foregroundStyle(color)
                
                // Current price indicator
                let currentY = currentNormalized * reader.size.height
                HStack(spacing: 2) {
                    Spacer()
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                    Text(currentPrice, format: .currency(code: "USD"))
                        .font(.caption2.bold())
                        .foregroundStyle(color)
                }
                .position(x: reader.size.width / 2, y: currentY)
            }
        }
        .background(backgroundDividers)
        .overlay(alignment: .leading) {
            PricesMinMax
        }
        
    }
    
    private var backgroundDividers: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var PricesMinMax: some View {
        VStack {
            Text(max, format: .currency(code: "USD"))
            Spacer()
            Text(min, format: .currency(code: "USD"))
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    StockChart(
        prices: [
            100,
            101,
            99,
            94,
            120,
            110,
            100,
            98,
            300,
            500,
            1000,
            100,
            101,
            99,
            94,
            120,
            110,
            100,
            98,
            300,
            500,
            1000,
            100,
            101,
            99,
            94,
            120,
            110,
            100,
            98,
            300,
            500,
            1000
        ],
        color: .accentColor
    )
        .frame(height: 100)
}
