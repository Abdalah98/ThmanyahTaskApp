//
//  ContentKind.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

enum ContentKind: String, Decodable, CaseIterable, Hashable {
    case podcast
    case episode
    case audiobook
    case audioArticle = "audio_article"

    init(from decoder: Decoder) throws {
        let raw = (try? decoder.singleValueContainer().decode(String.self))?.lowercased() ?? "podcast"
        self = ContentKind(rawValue: raw) ?? .podcast
    }
}