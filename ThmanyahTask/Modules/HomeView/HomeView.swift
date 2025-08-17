//
//  HomeView.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.sections) { section in
                        SectionView(section: section)
                            .onAppear { Task { await viewModel.loadMoreIfNeeded(current: section) } }
                    }
                    if viewModel.isLoading { ProgressView().padding() }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Home")
            .toolbar { NavigationLink(destination: SearchView(viewModel: SearchViewModel(repository: DefaultSearchRepository(client: DefaultHTTPClient())))) { Image(systemName: "magnifyingglass") } }
            .task { await viewModel.loadInitial() }
            .refreshable { await viewModel.loadInitial() }
            .alert(item: Binding.constant(viewModel.errorMessage.map(LocalizedErrorBox.init(message:)))) { box in
                Alert(title: Text("Error"), message: Text(box.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

