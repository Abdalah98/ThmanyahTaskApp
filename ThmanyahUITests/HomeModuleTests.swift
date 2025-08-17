//
//  HomeModuleTests.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 18/08/2025.
//

import XCTest
@testable import ThmanyahTask
 
final class HomeDecodingTests: XCTestCase {
    func testContentItemFlexibleDecoding() throws {
        let json = """
        {"podcast_id": 123, "name": "Item", "avatar_url":"https://e/1.jpg",
         "episode_count":"10","duration":"1800","priority":"1","popularityScore":"5","score":"4.5"}
        """.data(using: .utf8)!
        let item = try JSONDecoder().decode(ContentItem.self, from: json)
        XCTAssertEqual(item.podcastId, "123")
        XCTAssertEqual(item.episodeCount, 10)
        XCTAssertEqual(item.duration, 1800)
        XCTAssertEqual(item.score, 4.5, accuracy: 0.001)
    }

    func testHomeSectionFlexibleDecoding() throws {
        let json = """
        {"name":"Latest","type":"horizontal","content_type":"episode","order":"1","content":[]}
        """.data(using: .utf8)!
        let section = try JSONDecoder().decode(HomeSection.self, from: json)
        XCTAssertEqual(section.order, 1)
        XCTAssertEqual(section.contentType, .episode)
    }
}

final class HomeRepositoryTests: XCTestCase {

    // HTTPClient بديل بيرجع داتا ثابتة ويسجّل آخر URL
    struct StubHTTPClient: HTTPClient {
        var nextData: Data
        private(set) var lastURL: URL? = nil
        mutating func get(url: URL) async throws -> Data {
            lastURL = url
            return nextData
        }
    }

    func testFetchFirstPage_UsesHomeSectionsURL() async throws {
        let payload = """
        {"sections":[{"name":"Grid","type":"grid_2","content_type":"podcast","order":1,"content":[]}],
         "pagination":{"next_page":null,"total_pages":1}}
        """.data(using: .utf8)!

        var client = StubHTTPClient(nextData: payload)
        let repo = DefaultHomeRepository(client: client)

        _ = try await repo.fetchSections(pageURL: nil)
        // نتأكد إن البداية كانت /home_sections
        XCTAssertTrue(client.lastURL?.absoluteString.hasSuffix("/home_sections") == true)
    }

    func testResolvesRelativeNextPage() async throws {
        let first = """
        {"sections":[],
         "pagination":{"next_page":"/home_sections?page=2","total_pages":2}}
        """.data(using: .utf8)!
        var client = StubHTTPClient(nextData: first)
        let repo = DefaultHomeRepository(client: client)

        let res = try await repo.fetchSections(pageURL: nil)
        // هنركّب الـURL للصفحة التالية زي ما بيعمل الـVM؛
        // هنا بس نتأكد إن repo يقبل relative عند تمريره مستقبلاً
        let relative = URL(string: "/home_sections?page=2")!
        client.nextData = """
        {"sections":[], "pagination":{"next_page":null,"total_pages":2}}
        """.data(using: .utf8)!

        _ = try await repo.fetchSections(pageURL: relative)
        XCTAssertEqual(client.lastURL?.host, "api-v2-b2sit6oh3a-uc.a.run.app") // اتحلت للمطلق عبر APIEndpoint.base
    }
}

@MainActor
final class HomeViewModelTests: XCTestCase {

    // Repository بديل لحقن ردود متسلسلة
    struct MockHomeRepo: HomeRepository {
        var responses: [HomeResponse]
        private var index = 0
        mutating func fetchSections(pageURL: URL?) async throws -> HomeResponse {
            defer { if index < responses.count - 1 { index += 1 } }
            return responses[index]
        }
    }

    func testLoadInitial_PopulatesSectionsAndNext() async {
        let page1 = HomeResponse(
            sections: [HomeSection(name: "Grid", type: "grid_2", contentType: .podcast, order: 1, content: [])],
            pagination: Pagination(nextPage: "/home_sections?page=2", totalPages: 2)
        )
        let page2 = HomeResponse(
            sections: [HomeSection(name: "Latest", type: "horizontal", contentType: .episode, order: 2, content: [])],
            pagination: Pagination(nextPage: nil, totalPages: 2)
        )

        var repo = MockHomeRepo(responses: [page1, page2])
        let vm = HomeViewModel(repository: repo)

        await vm.loadInitial()
        XCTAssertEqual(vm.sections.count, 1)

        // حاكي الـonAppear للنهاية → prefetch
        let last = vm.sections.last
        await vm.loadMoreIfNeeded(current: last)
        XCTAssertEqual(vm.sections.count, 2)
    }
}
