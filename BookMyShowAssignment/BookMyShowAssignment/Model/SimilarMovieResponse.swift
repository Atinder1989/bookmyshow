//
//  SimilarMovieResponse.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation

struct SimilarMovieResponse: Codable {
    var movieList: [Movie]

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.movieList = try container.decodeIfPresent([Movie].self, forKey: .results) ?? []
    }

}
