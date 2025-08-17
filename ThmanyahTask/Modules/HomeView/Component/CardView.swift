//
//  CardView.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct CardView: View {
    let item: ContentItem
    let kind: ContentKind

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImage(urlString: item.avatarUrl)
                .frame(height: kind == .episode ? 120 : 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(item.name ?? "Untitled").appFont(.subheadline).lineLimit(2)

            if let desc = item.description?.htmlToPlainString, kind != .episode {
                Text(desc).appFont(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
            if let duration = item.duration, kind == .episode {
                Text("\(duration / 60) min").appFont(.caption2).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
