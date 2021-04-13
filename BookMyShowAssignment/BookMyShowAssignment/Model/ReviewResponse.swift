//
//  ReviewResponse.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation


struct ReviewResponse: Codable {
    var reviewList: [Review]

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.reviewList = try container.decodeIfPresent([Review].self, forKey: .results) ?? []
    }

    func encode(to encoder: Encoder) throws {

    }
}


struct Review: Codable {
    var author: String
    var content: String
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }

    func encode(to encoder: Encoder) throws {

    }
}


