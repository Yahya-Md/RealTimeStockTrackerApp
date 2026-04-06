//
//  ConnectionStatusView.swift
//  RealTimeStockTracker

import SwiftUI

enum ConnectionStatus: String {
    case connected = "Connected"
    case disconnected = "Disconnected"
}

struct ConnectionStatusView: View {
    let status: ConnectionStatus

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(status == .connected ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            Text(status.rawValue)
                .font(.caption)
                .foregroundStyle(status == .connected ? Color.green : Color.red)
        }
    }
}
