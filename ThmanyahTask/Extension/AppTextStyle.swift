//
//  AppTextStyle.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import SwiftUI

enum AppTextStyle { case title, headline, subheadline, body, caption, caption2 }

struct AppFont {
    static func font(_ style: AppTextStyle, weight: Font.Weight = .regular) -> Font {
        switch style {
        case .title:       return .ibmArabic(weight, size: 28)
        case .headline:    return .ibmArabic(weight, size: 17)
        case .subheadline: return .ibmArabic(weight, size: 15)
        case .body:        return .ibmArabic(weight, size: 16)
        case .caption:     return .ibmArabic(weight, size: 13)
        case .caption2:    return .ibmArabic(weight, size: 12)
        }
    }
}

extension View {
    @inline(__always)
    func appFont(_ style: AppTextStyle, weight: Font.Weight = .regular) -> some View {
        self.font(AppFont.font(style, weight: weight))
    }
}
