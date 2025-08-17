//
//  DetailPayload.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

struct DetailPayload: Hashable {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: URL?
    let description: String?
    let kind: ContentKind
}

extension DetailPayload {
    init(item: ContentItem, kind: ContentKind) {
        self.id = item.podcastId ?? item.name ?? UUID().uuidString
        self.title = item.name ?? "Untitled"
        self.subtitle = (kind == .episode && item.duration != nil) ? "\( (item.duration ?? 0) / 60 ) min" : nil
        self.imageURL = URL(string: item.avatarUrl ?? "")
        self.description = item.description
        self.kind = kind
    }
}
