//
//  SquareTile.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct SquareTile: View {
    let item: ContentItem
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImage(urlString: item.avatarUrl)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading) {
                Text(item.name ?? "").appFont(.subheadline, weight: .semibold).foregroundColor(.white).lineLimit(2)
            }.padding(10)
        }
    }
}