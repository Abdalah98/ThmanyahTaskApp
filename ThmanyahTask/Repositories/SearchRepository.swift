//
//  SearchRepository.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

protocol SearchRepository { func search(query: String, pageURL: URL?) async throws -> HomeResponse }

struct DefaultSearchRepository: SearchRepository {
    let client: HTTPClient

    func search(query: String, pageURL: URL?) async throws -> HomeResponse {
        let requestURL: URL
        if let pageURL {
            requestURL = (pageURL.scheme != nil) ? pageURL : APIEndpoint.relative(pageURL.absoluteString, base: APIEndpoint.searchBase).url()
        } else {
            var comps = URLComponents(url: APIEndpoint.searchBase.appendingPathComponent("search"), resolvingAgainstBaseURL: false)!
            comps.queryItems = [URLQueryItem(name: "q", value: query)]
            requestURL = comps.url!
        }
        let data = try await client.get(url: requestURL)
        let decoder = JSONDecoder()

        // Try HomeResponse first (some mocks already return sections/pagination)
        if let res = try? decoder.decode(HomeResponse.self, from: data) { return res }

        // Try common wrappers
        if let alt = try? decoder.decode(SearchListResults.self, from: data) { return HomeResponse(sections: Self.wrap(items: alt.results), pagination: alt.pagination) }
        if let alt = try? decoder.decode(SearchListItems.self, from: data) { return HomeResponse(sections: Self.wrap(items: alt.items), pagination: alt.pagination) }
        if let alt = try? decoder.decode(SearchListData.self, from: data) { return HomeResponse(sections: Self.wrap(items: alt.data), pagination: alt.pagination) }
        if let items = try? decoder.decode([ContentItem].self, from: data) { return HomeResponse(sections: Self.wrap(items: items), pagination: nil) }

        let snippet = String(data: data, encoding: .utf8)?.prefix(300) ?? "(\(data.count) bytes)"
        throw HumanError(message: "Unexpected search response format. Sample: \(snippet)")
    }

    // Heuristic grouping to sections (so UI matches home screen layout)
    static func wrap(items: [ContentItem]) -> [HomeSection] {
        guard !items.isEmpty else { return [] }
        let groups = Dictionary(grouping: items) { (item) -> ContentKind in
            if let ec = item.episodeCount, ec > 0 { return .podcast }
            if let d = item.duration, d > 0 { return .episode }
            return .podcast
        }
        return groups
            .sorted { $0.key.rawValue < $1.key.rawValue }
            .enumerated()
            .map { index, pair in
                let (kind, list) = pair
                let type  = (kind == .episode) ? "horizontal" : "grid_2"
                let title = (kind == .episode) ? "حلقات"    : "بودكاست"
                return HomeSection(name: title, type: type, contentType: kind, order: index + 1, content: list)
            }
    }
}

private struct SearchListResults: Decodable { let results: [ContentItem]; let pagination: Pagination? }
private struct SearchListItems: Decodable { let items: [ContentItem]; let pagination: Pagination? }
private struct SearchListData: Decodable { let data: [ContentItem]; let pagination: Pagination? }

struct HumanError: LocalizedError { let message: String; var errorDescription: String? { message } }