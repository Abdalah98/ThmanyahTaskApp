//
//  SearchModuleTests.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 18/08/2025.
//

import XCTest
@testable import ThmanyahTask

final class SearchRepositoryTests: XCTestCase {

    struct StubHTTPClient: HTTPClient {
        var nextData: Data
        private(set) var lastURL: URL? = nil
        mutating func get(url: URL) async throws -> Data {
            lastURL = url
            return nextData
        }
    }

    func testBuildsSearchURLWithQueryParam() async throws {
        let payload = """
        {"sections":[], "pagination":{"next_page":null,"total_pages":1}}
        """.data(using: .utf8)!

        var client = StubHTTPClient(nextData: payload)
        let repo = DefaultSearchRepository(client: client)

        _ = try await repo.search(query: "Th", pageURL: nil)
        let s = client.lastURL?.absoluteString ?? ""
        XCTAssertTrue(s.contains("/search"))
        XCTAssertTrue(s.contains("q=Th"))
    }

    func testAcceptsAlternateWrappers_resultsItemsData() async throws {
         var client = StubHTTPClient(nextData: """
        {"results":[{"podcast_id":"p1","name":"Hello","avatar_url":"https://e/1.jpg"}],
         "pagination":{"next_page":"/search?page=2","total_pages":2}}
        """.data(using: .utf8)!)
        let repo = DefaultSearchRepository(client: client)
        var res = try await repo.search(query: "x", pageURL: nil)
        XCTAssertGreaterThanOrEqual(res.sections.count, 1)

         client.nextData = """
        {"items":[{"podcast_id":"p2","name":"World","avatar_url":"https://e/2.jpg"}],
         "pagination":{"next_page":null,"total_pages":1}}
        """.data(using: .utf8)!
        res = try await repo.search(query: "y", pageURL: nil)
        XCTAssertGreaterThanOrEqual(res.sections.count, 1)

         client.nextData = """
        [{"podcast_id":"p3","name":"Array","avatar_url":"https://e/3.jpg"}]
        """.data(using: .utf8)!
        res = try await repo.search(query: "z", pageURL: nil)
        XCTAssertGreaterThanOrEqual(res.sections.count, 1)
    }
}

@MainActor
final class SearchViewModelTests: XCTestCase {

    struct MockSearchRepo: SearchRepository {
        var script: [HomeResponse]
        private var index = 0
        mutating func search(query: String, pageURL: URL?) async throws -> HomeResponse {
            defer { if index < script.count - 1 { index += 1 } }
            return script[index]
        }
    }

    func testShortQueriesClearAndDontHitNetwork() async {
        var repo = MockSearchRepo(script: [])
        let vm = SearchViewModel(repository: repo)

        await vm.start(query: "a") // أقل من 2
        XCTAssertTrue(vm.sections.isEmpty)
        XCTAssertNil(await withCheckedContinuation { cont in cont.resume(returning: vm.errorMessage) })
    }

    func testCachingAndDeduping() async {
        let page = HomeResponse(
            sections: [HomeSection(name: "Podcasts", type: "grid_2", contentType: .podcast, order: 1, content: [])],
            pagination: Pagination(nextPage: "/search?page=2", totalPages: 2)
        )
         var repo = MockSearchRepo(script: [page, page])
        let vm = SearchViewModel(repository: repo)

        await vm.start(query: "th")
        let countAfterFirst = vm.sections.count

         await vm.start(query: "th")
        XCTAssertEqual(vm.sections.count, countAfterFirst)
    }

    func testLoadMoreIfHasNextPage() async {
        let page1 = HomeResponse(
            sections: [HomeSection(name: "P1", type: "grid_2", contentType: .podcast, order: 1, content: [])],
            pagination: Pagination(nextPage: "/search?page=2", totalPages: 2)
        )
        let page2 = HomeResponse(
            sections: [HomeSection(name: "P2", type: "grid_2", contentType: .podcast, order: 2, content: [])],
            pagination: Pagination(nextPage: nil, totalPages: 2)
        )
        var repo = MockSearchRepo(script: [page1, page2])
        let vm = SearchViewModel(repository: repo)

        await vm.start(query: "th")
        XCTAssertEqual(vm.sections.count, 1)

        let last = vm.sections.last
        await vm.loadMoreIfNeeded(current: last)
        XCTAssertEqual(vm.sections.count, 2)
    }
}
