//
//  File.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 18/08/2025.
//


import Foundation

extension String {
    var htmlToPlainString: String {
         let withBreaks = self
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .replacingOccurrences(of: "<br />", with: "\n")

         if let data = withBreaks.data(using: .utf8),
           let attr = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
           ) {
            return attr.string
        }

         return withBreaks.replacingOccurrences(of: "<[^>]+>", with: "",
                                               options: .regularExpression, range: nil)
    }
}