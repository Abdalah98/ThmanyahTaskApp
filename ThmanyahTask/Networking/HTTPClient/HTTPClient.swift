//
//  HTTPClient.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

protocol HTTPClient { func get(url: URL) async throws -> Data }

struct DefaultHTTPClient: HTTPClient {
    func get(url: URL) async throws -> Data {
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}