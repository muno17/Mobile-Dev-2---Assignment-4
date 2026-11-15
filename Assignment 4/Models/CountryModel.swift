//
//  CountryModel.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import Foundation

struct Country : Codable, Identifiable {
    var id : String { cca3 }
    var cca3 : String
    var cca2 : String
    var name : CountryName
    var capital : [String]?
    var region : String?
    var subregion : String?
    var population : Int?
    var area : Double?
    var landlocked : Bool?
    var unMember : Bool?
    var latlng : [Double]?
    var languages : [String : String]?
    var currencies : [String : Currency]?
    
    func flagURL(width: Int) -> URL? {
        URL(string: "https://flagcdn.com/w\(width)/\(cca2.lowercased()).png")
    }
}

struct CountryName : Codable {
    var common : String
    var official : String?
}

struct Currency : Codable {
    var name : String?
    var symbol : String?
}

// the API returns a two-item array: [paging info, [rows]]

struct PopulationResponse : Decodable {
    let rows : [PopulationRow]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        _ = try container.decode(PopulationMeta.self)   // paging info, ignored
        rows = try container.decode([PopulationRow].self)
    }
}

struct PopulationMeta : Decodable {}

struct PopulationRow : Decodable {
    let countryiso3code : String?
    let date : String
    let value : Double?
}
