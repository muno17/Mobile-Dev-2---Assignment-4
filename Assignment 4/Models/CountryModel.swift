//
//  CountryModel.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    let name: Name
    let cca3: String
    let capital: [String]?
    let region: String?
    let subregion: String?
    let population: Int?
    let area: Double?
    let flags: Flags?
    let languages: [String: String]?
    let currencies: [String: Currency]?

    var id: String { cca3 }

    struct Name: Codable, Hashable {
        let common: String
        let official: String?
    }

    struct Flags: Codable, Hashable {
        let png: String?
        let alt: String?
    }

    struct Currency: Codable, Hashable {
        let name: String?
        let symbol: String?
    }


    var flagURL: URL? { flags?.png.flatMap(URL.init(string:)) }

    var capitalText: String {
        guard let capital, !capital.isEmpty else { return "No capital" }
        return capital.joined(separator: ", ")
    }

    var languageText: String {
        guard let languages, !languages.isEmpty else { return "Unknown" }
        return languages.values.sorted().joined(separator: ", ")
    }

    var currencyText: String {
        guard let currencies, !currencies.isEmpty else { return "Unknown" }
        return currencies.values.compactMap { currency in
            guard let name = currency.name else { return nil }
            if let symbol = currency.symbol { return "\(name) (\(symbol))" }
            return name
        }
        .sorted()
        .joined(separator: ", ")
    }

    var populationText: String {
        population.map { $0.formatted() } ?? "Unknown"
    }

    var areaText: String {
        area.map { "\($0.formatted(.number.precision(.fractionLength(0)))) km²" } ?? "Unknown"
    }
}
