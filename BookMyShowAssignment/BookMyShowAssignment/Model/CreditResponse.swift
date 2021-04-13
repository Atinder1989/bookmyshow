//
//  CreditResponse.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation

struct CreditResponse: Codable {
    var castList: [Cast]
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.castList = try container.decodeIfPresent([Cast].self, forKey: .cast) ?? []
    }

    func encode(to encoder: Encoder) throws {

    }
}


struct Cast: Codable {
    var id : Int
    var name: String
    var character: String
    var profile_path: String

    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.character = try container.decodeIfPresent(String.self, forKey: .character) ?? ""
        let path = try container.decodeIfPresent(String.self, forKey: .profile_path) ?? ""
        self.profile_path = imagebaseUrl + path
    }

    func encode(to encoder: Encoder) throws {

    }
}
