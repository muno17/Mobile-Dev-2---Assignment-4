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
    var name : CountryName
    var capital : [String]?
    var region : String?
    var subregion : String?
    var population : Int?
    var area : Double?
    var flags : Flags?
    var languages : [String : String]?
    var currencies : [String : Currency]?
}

struct CountryName : Codable {
    var common : String
    var official : String?
}

struct Flags : Codable {
    var png : String?
}

struct Currency : Codable {
    var name : String?
    var symbol : String?
}
