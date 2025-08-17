//
//  DetailsVCWrapper.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

struct DetailsVCWrapper: UIViewControllerRepresentable {
    let payload: DetailPayload

    func makeUIViewController(context: Context) -> DetailsViewController {
        let vc = DetailsViewController()
        vc.payload = payload
        return vc
    }
    func updateUIViewController(_ uiViewController: DetailsViewController, context: Context) {}
}