//
//  RemoteImage.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct RemoteImage: View {
    let urlString: String?
    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty: ZStack { ProgressView() }.frame(maxWidth: .infinity)
                case .success(let image): image.resizable().scaledToFill()
                case .failure: placeholder
                @unknown default: placeholder
                }
            }
        } else { placeholder }
    }
    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.15)).overlay(Image(systemName: "photo").imageScale(.large).foregroundStyle(.secondary))
    }
}
