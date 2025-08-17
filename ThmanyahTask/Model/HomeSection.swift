//
//  HomeSection.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

struct HomeSection: Decodable, Identifiable, Hashable {
    var id: String { "\(name)-\(order)" }

    let name: String
    let type: String?
    let contentType: ContentKind
    let order: Int
    let content: [ContentItem]

    enum CodingKeys: String, CodingKey { case name, type, order, content; case contentType = "content_type" }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? c.decode(String.self, forKey: .name)) ?? ""
        type = try? c.decodeIfPresent(String.self, forKey: .type)
        contentType = (try? c.decode(ContentKind.self, forKey: .contentType)) ?? .podcast
        if let v = try? c.decode(Int.self, forKey: .order) { order = v }
        else if let s = try? c.decode(String.self, forKey: .order), let v = Int(s) { order = v } else { order = 0 }
        content = (try? c.decode([ContentItem].self, forKey: .content)) ?? []
    }
}

// Memberwise-style initializer for manual construction
extension HomeSection {
    init(name: String, type: String?, contentType: ContentKind, order: Int, content: [ContentItem]) {
        self.name = name
        self.type = type
        self.contentType = contentType
        self.order = order
        self.content = content
    }
}