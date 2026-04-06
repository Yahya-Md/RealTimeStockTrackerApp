# RealTimeStockTracker

A SwiftUI iOS app that displays real-time stock price updates using WebSockets. Prices are generated locally and echoed through a WebSocket server, simulating a live stock feed.

## Features

- **Live Price Updates** — Real-time stock prices streamed via WebSocket (`wss://ws.postman-echo.com/raw`)
- **Stock List** — Browse 9 major tech stocks (AAPL, GOOG, TSLA, AMZN, MSFT, NVDA, META, NFLX, etc.)
- **Sorting** — Sort by current price or price change magnitude
- **Stock Details** — Tap any stock to see full details with price chart
- **Price Chart** — Line chart showing price history with min/max labels and current price indicator
- **Connection Control** — Start/stop the live feed with a toolbar button
- **Status Indicator** — Green/red badge showing connection status

## Architecture

The app follows **MVVM** with protocol-based dependency injection:

```
Views → ViewModel → Services → Core
```

| Layer | Responsibility |
|-------|---------------|
| **Views** | SwiftUI components (`StocksList`, `StockDetails`, `StockChart`, etc.) |
| **ViewModel** | `StockListViewModel` — observable state, sorting, update logic |
| **Services** | `StocksListService` (JSON loading), `StocksWebSocketService` (stream decoding) |
| **Core** | `WebSocketSession` (URLSession WebSocket), `JsonLoader` (generic JSON reader) |

## How It Works

1. Stocks load from a bundled `stocks.json` file on launch
2. User taps **Start** to open a WebSocket connection
3. A `RandomPriceGenerator` creates price updates (±2% fluctuations) every 0.5s
4. Updates are sent to the echo server and received back as `PriceUpdate` objects
5. The UI reactively updates prices, charts, and change indicators

## Tech Stack

- **SwiftUI** with `@Observable` (iOS 17+)
- **URLSessionWebSocketTask** for WebSocket communication
- **AsyncStream** for non-blocking data streaming
- **async/await** concurrency
- **`@MainActor`** for thread-safe UI updates
- **Protocol-oriented design** for testability

## Project Structure

```
RealTimeStockTracker/
├── Core/
│   ├── JsonLoader/          # Generic async JSON file loader
│   └── WebSocket/           # WebSocket session management
├── Models/
│   ├── StockResponse.swift  # JSON DTO
│   └── PriceUpdate.swift    # Real-time update model
├── Mapper/                  # StockResponse → Stock entity mapping
├── Services/
│   ├── StocksListService    # Loads stocks from JSON
│   └── StocksWebSocketService # Decodes WebSocket stream
├── Utilities/
│   └── PriceGenerator       # Random price update generator
├── ViewModels/
│   └── StockListViewModel   # App state & business logic
├── Views/
│   ├── StocksList/          # Main list view
│   ├── StockDetails/        # Detail view with chart
│   ├── Components/          # StockItem, StockChart, PriceChangeIndicator
│   └── Entities/            # Stock domain model
└── Resources/
    └── stocks.json          # Stock data source
```

## Requirements

- iOS 17.0+
- Xcode 15+
- Swift 5.9+

## Getting Started

1. Clone the repository
2. Open `RealTimeStockTracker.xcodeproj` in Xcode
3. Build and run on a simulator or device
4. Tap **Start** to begin receiving live price updates
