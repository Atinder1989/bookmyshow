//
//  MovieListResponse.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation

struct MovieListResponse: Codable {
    var page: Int
    var total_pages: Int
    var total_results: Int
    var movielist :[Movie]

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        self.total_pages = try container.decodeIfPresent(Int.self, forKey: .total_pages) ?? 0
        self.total_results = try container.decodeIfPresent(Int.self, forKey: .total_results) ?? 0
        self.movielist = try container.decodeIfPresent([Movie].self, forKey: .results) ?? []
    }

    func encode(to encoder: Encoder) throws {

    }
}
