//
//  HomeViewModel.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var sections: [SectionVM] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let repository: HomeRepository
    private var nextPageURL: URL? = nil
    private var isFirstLoad = true

    init(repository: HomeRepository) { self.repository = repository }

    func loadInitial() async {
        guard isFirstLoad else { return }
        isFirstLoad = false
        sections = []
        nextPageURL = nil
        await loadMore()
    }

    func loadMoreIfNeeded(current section: SectionVM?) async {
        guard let section = section else { await loadMore(); return }
        let thresholdIndex = max(0, sections.count - 3)
        if sections.firstIndex(where: { $0.id == section.id }) == thresholdIndex { await loadMore() }
    }

    private func loadMore() async {
        guard !isLoading else { return }
        guard sections.isEmpty || nextPageURL != nil else { return }
        isLoading = true; errorMessage = nil
        do {
            let res = try await repository.fetchSections(pageURL: nextPageURL)
            sections.append(contentsOf: res.sections.map(SectionVM.init))
            if let next = res.pagination?.nextPage, !next.isEmpty {
                if let abs = URL(string: next), abs.scheme != nil { nextPageURL = abs }
                else { nextPageURL = URL(string: next, relativeTo: APIEndpoint.base)?.absoluteURL }
            } else { nextPageURL = nil }
        } catch { errorMessage = (error as NSError).localizedDescription }
        isLoading = false
    }
}
