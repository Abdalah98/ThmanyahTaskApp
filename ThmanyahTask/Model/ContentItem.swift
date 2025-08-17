//
//  ContentItem.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

struct ContentItem: Decodable, Identifiable, Hashable {
    let podcastId: String?
    let name: String?
    let description: String?
    let avatarUrl: String?
    let episodeCount: Int?
    let duration: Int?
    let language: String?
    let priority: Int?
    let popularityScore: Int?
    let score: Double?

    var id: String { podcastId ?? name ?? UUID().uuidString }

    enum CodingKeys: String, CodingKey {
        case name, description, language, priority, popularityScore, score
        case podcastId = "podcast_id"
        case avatarUrl = "avatar_url"
        case episodeCount = "episode_count"
        case duration
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        func flexString(_ k: CodingKeys) -> String? { (try? c.decodeIfPresent(String.self, forKey: k)) ?? (try? c.decodeIfPresent(Int.self, forKey: k)).map(String.init) }
        func flexInt(_ k: CodingKeys) -> Int? { (try? c.decodeIfPresent(Int.self, forKey: k)) ?? ((try? c.decodeIfPresent(String.self, forKey: k)).flatMap { Int($0) }) }
        func flexDouble(_ k: CodingKeys) -> Double? { (try? c.decodeIfPresent(Double.self, forKey: k)) ?? ((try? c.decodeIfPresent(String.self, forKey: k)).flatMap { Double($0) }) }

        podcastId = flexString(.podcastId)
        name = try? c.decodeIfPresent(String.self, forKey: .name)
        description = try? c.decodeIfPresent(String.self, forKey: .description)
        avatarUrl = try? c.decodeIfPresent(String.self, forKey: .avatarUrl)
        episodeCount = flexInt(.episodeCount)
        duration = flexInt(.duration)
        language = try? c.decodeIfPresent(String.self, forKey: .language)
        priority = flexInt(.priority)
        popularityScore = flexInt(.popularityScore)
        score = flexDouble(.score)
    }
}
