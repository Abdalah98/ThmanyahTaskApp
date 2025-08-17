//
//  SearchViewModel.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @Published private(set) var sections: [SectionVM] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let repository: SearchRepository
    private var nextPageURL: URL? = nil
    private(set) var currentQuery: String = ""
    private var cache: [String: (sections: [SectionVM], next: URL?)] = [:]

    init(repository: SearchRepository) { self.repository = repository }

    func start(query: String) async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard q.count >= 2 else { currentQuery = ""; sections = []; nextPageURL = nil; return }
        guard q != currentQuery || sections.isEmpty else { return }

        if let cached = cache[q] { currentQuery = q; sections = cached.sections; nextPageURL = cached.next; return }

        isLoading = true; errorMessage = nil
        do {
            let res = try await repository.search(query: q, pageURL: nil)
            let vms = res.sections.map(SectionVM.init)
            sections = vms
            nextPageURL = resolveNext(res.pagination?.nextPage, base: APIEndpoint.searchBase)
            currentQuery = q
            cache[q] = (vms, nextPageURL)
        } catch { errorMessage = (error as NSError).localizedDescription }
        isLoading = false
    }

    func loadMoreIfNeeded(current section: SectionVM?) async {
        guard let section = section else { await loadMore(); return }
        let thresholdIndex = max(0, sections.count - 3)
        if sections.firstIndex(where: { $0.id == section.id }) == thresholdIndex { await loadMore() }
    }

    private func loadMore() async {
        guard !isLoading, let pageURL = nextPageURL, !currentQuery.isEmpty else { return }
        isLoading = true
        do {
            let res = try await repository.search(query: currentQuery, pageURL: pageURL)
            let newVMs = res.sections.map(SectionVM.init)
            sections.append(contentsOf: newVMs)
            nextPageURL = resolveNext(res.pagination?.nextPage, base: APIEndpoint.searchBase)
            cache[currentQuery] = (sections, nextPageURL)
        } catch { errorMessage = (error as NSError).localizedDescription }
        isLoading = false
    }

    private func resolveNext(_ next: String?, base: URL) -> URL? {
        guard let next, !next.isEmpty else { return nil }
        if let abs = URL(string: next), abs.scheme != nil { return abs }
        return URL(string: next, relativeTo: base)?.absoluteURL
    }
}
