//
//  JsonLoader.swift
//  RealTimeStockTracker
//
//  Created by Renault on 1/4/2026.
//

import Foundation

public protocol JsonLoadable {
    func fetch<T: Decodable>(for name: String) async throws -> T
}

public class JsonLoader: JsonLoadable {
    private let bundle: Bundle
    
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    
    public enum JsonLoaderError: Error {
        case fileNotFound
        case failedToDecode
    }
    
    public func fetch<T: Decodable>(for name: String) async throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw JsonLoaderError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw JsonLoaderError.failedToDecode
        }
    }
}
