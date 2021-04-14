//
//  SynopsisResponse.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation

struct SynopsisResponse: Codable {
    var id: Int
    var runtime: Int
    var productionCompanyList :[SynopsisProductionCompany]

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        self.productionCompanyList = try container.decodeIfPresent([SynopsisProductionCompany].self, forKey: .production_companies) ?? []
    }

   
}

struct SynopsisProductionCompany: Codable {
    var id: Int
    var logo_path: String
    var name: String
    var origin_country :String

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceParsingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.logo_path = try container.decodeIfPresent(String.self, forKey: .logo_path) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.origin_country = try container.decodeIfPresent(String.self, forKey: .origin_country) ?? ""
    }

   
}


