//
//  Movie.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation

struct Movie: Codable {
    var adult: Bool
    var backdrop_path: String
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdrop_path) ?? ""
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 1
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language) ?? ""
        self.original_title = try container.decodeIfPresent(String.self, forKey: .original_title) ?? ""
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        let path = try container.decodeIfPresent(String.self, forKey: .poster_path) ?? ""
        self.poster_path = imagebaseUrl + path
        self.release_date = try container.decodeIfPresent(String.self, forKey: .release_date) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        self.vote_average = try container.decodeIfPresent(Double.self, forKey: .vote_average) ?? 0.0
        self.vote_count = try container.decodeIfPresent(Int.self, forKey: .vote_count) ?? 1

    }

    func encode(to encoder: Encoder) throws {

    }
}
