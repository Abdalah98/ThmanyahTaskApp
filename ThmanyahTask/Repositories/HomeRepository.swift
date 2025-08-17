//
//  HomeRepository.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

protocol HomeRepository { func fetchSections(pageURL: URL?) async throws -> HomeResponse }

struct DefaultHomeRepository: HomeRepository {
    let client: HTTPClient

    func fetchSections(pageURL: URL?) async throws -> HomeResponse {
        let url: URL
        if let pageURL {
            url = (pageURL.scheme != nil) ? pageURL : APIEndpoint.relative(pageURL.absoluteString, base: APIEndpoint.base).url()
        } else {
            url = APIEndpoint.homeSections.url()
        }
        let data = try await client.get(url: url)
        return try JSONDecoder().decode(HomeResponse.self, from: data)
    }
}