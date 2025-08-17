//
//  HomeResponse.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//


import Foundation

struct HomeResponse: Decodable {
    let sections: [HomeSection]
    let pagination: Pagination?
}

struct Pagination: Decodable {
    let nextPage: String?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey { case nextPage = "next_page", totalPages = "total_pages" }
}