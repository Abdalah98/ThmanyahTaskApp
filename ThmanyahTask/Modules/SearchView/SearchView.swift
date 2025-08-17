//
//  SearchView.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var query: String = ""
    @State private var debounceTask: Task<Void, Never>? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
                    Text("Type at least 2 characters to search").foregroundStyle(.secondary).padding(.top, 40)
                } else {
                    ForEach(viewModel.sections) { section in
                        SectionView(section: section)
                            .onAppear { Task { await viewModel.loadMoreIfNeeded(current: section) } }
                    }
                }
                if viewModel.isLoading { ProgressView().padding() }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Search")
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search…")
        .onChange(of: query) { newValue in
            debounceTask?.cancel()
            debounceTask = Task { [newValue] in
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
                await viewModel.start(query: trimmed)
            }
        }
        .onSubmit(of: .search) { Task { await viewModel.start(query: query.trimmingCharacters(in: .whitespacesAndNewlines)) } }
        .alert(item: Binding.constant(viewModel.errorMessage.map(LocalizedErrorBox.init(message:)))) { box in
            Alert(title: Text("Error"), message: Text(box.message), dismissButton: .default(Text("OK")))
        }
    }
}
