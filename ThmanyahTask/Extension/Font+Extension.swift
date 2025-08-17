//
//  Font+Extension.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 16/08/2025.
//

import SwiftUI


extension Font {
    static func ibmArabic(_ weight: Font.Weight, size: CGFloat) -> Font {
        switch weight {
        case .bold:
            return .custom("IBMPlexSansArabic-Bold", size: size)
        case .semibold:
            return .custom("IBMPlexSansArabic-SemiBold", size: size)
        case .medium:
            return .custom("IBMPlexSansArabic-Medium", size: size)
        case .light:
            return .custom("IBMPlexSansArabic-Light", size: size)
        case .thin:
            return .custom("IBMPlexSansArabic-Thin", size: size)
        case .ultraLight:
            return .custom("IBMPlexSansArabic-ExtraLight", size: size)
        default:
            return .custom("IBMPlexSansArabic-Regular", size: size)
        }
    }
}

