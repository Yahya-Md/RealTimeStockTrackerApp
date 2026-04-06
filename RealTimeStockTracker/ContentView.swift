//
//  ContentView.swift
//  RealTimeStockTracker
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: StockListViewModel
    
    init() {
        let service = StocksListServiceImpl(
            loader: JsonLoader(bundle: .main),
        )
        let session = WebSocketSession(
            url: URL(string: "wss://ws.postman-echo.com/raw")!,
            session: URLSession.shared)
        self.viewModel = StockListViewModel(
            service: service,
            socketService: StocksWebSocketService(webSocket: session)
        )
    }
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
