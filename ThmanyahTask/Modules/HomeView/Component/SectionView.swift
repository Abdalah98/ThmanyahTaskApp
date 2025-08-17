//
//  SectionView.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct SectionView: View {
    let section: SectionVM

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Text(section.title).appFont(.headline, weight: .semibold); Spacer() }
            contentBody
        }
    }

    @ViewBuilder
    private var contentBody: some View {
        switch section.layout {
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                        NavigationLink {
                            DetailsVCWrapper(payload: DetailPayload(item: item, kind: section.kind))
                        } label: {
                            CardView(item: item, kind: section.kind)
                        }
                        .buttonStyle(.plain)
                     }
                }.padding(.vertical, 4)
            }

        case .gridTwo:
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                    NavigationLink {
                        DetailsVCWrapper(payload: DetailPayload(item: item, kind: section.kind))
                    } label: {
                        CardView(item: item, kind: section.kind)
                    }
                    .buttonStyle(.plain)
                }
            }

        case .squareGrid:
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                    NavigationLink {
                        DetailsVCWrapper(payload: DetailPayload(item: item, kind: section.kind))
                    } label: {
                        SquareTile(item: item).aspectRatio(1, contentMode: .fit)
                    }
                    .buttonStyle(.plain)
                }
            }

        case .gridAuto(let columns):
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: max(1, columns)), spacing: 10) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                    NavigationLink {
                        DetailsVCWrapper(payload: DetailPayload(item: item, kind: section.kind))
                    } label: {
                        CardView(item: item, kind: section.kind)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
