//
//  SectionVM.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//

import Foundation
struct SectionVM: Identifiable {
    let id: String
    let title: String
    let layout: SectionLayout
    let kind: ContentKind
    let items: [ContentItem]

    init(model: HomeSection) {
        id = model.id
        title = model.name
        kind = model.contentType
        layout = SectionLayout(raw: model.type, fallbackBy: model.contentType)
        items = model.content
    }
}

enum SectionLayout: Equatable { case gridTwo, squareGrid, horizontal, gridAuto(columns: Int)
    init(raw backendType: String?, fallbackBy content: ContentKind) {
        let key = (backendType ?? "").lowercased()
        switch key {
        case "grid_two", "two_column_grid", "grid2", "grid_2": self = .gridTwo
        case "square_grid", "grid_square", "squares": self = .squareGrid
        case "horizontal", "carousel", "hscroll": self = .horizontal
        case let s where s.hasPrefix("grid_"):
            if let n = Int(s.replacingOccurrences(of: "grid_", with: "")) { self = .gridAuto(columns: max(1, n)); break }
            fallthrough
        default:
            self = (content == .episode) ? .horizontal : .gridTwo
        }
    }
}
