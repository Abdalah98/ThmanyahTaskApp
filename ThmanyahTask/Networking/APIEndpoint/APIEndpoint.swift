//
//  APIEndpoint.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

enum APIEndpoint {
    static let base = URL(string: "https://api-v2-b2sit6oh3a-uc.a.run.app")!
    static let searchBase = URL(string: "https://mock.apidog.com/m1/735111-711675-default")!

    case homeSections                // first page
    case absolute(URL)               // fully-qualified URL
    case relative(String, base: URL) // relative path like "/home_sections?page=2"

    func url() -> URL {
        switch self {
        case .homeSections:
            return APIEndpoint.base.appendingPathComponent("home_sections")
        case .absolute(let u):
            return u
        case .relative(let path, let base):
            return URL(string: path, relativeTo: base)!.absoluteURL
        }
    }
}