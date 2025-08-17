//
//  ThmanyahTaskApp.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 16/08/2025.
//

import SwiftUI

@main
struct HomeSectionsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(
                    repository: DefaultHomeRepository(
                        client: DefaultHTTPClient()
                    )
                )
            )
        }
    }
}
