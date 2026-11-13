//
//  CountryDetailView.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import SwiftUI

struct CountryDetailView: View {
    
    var country : Country
    
    var languageText : String {
        let names = country.languages?.values.sorted() ?? []
        return names.isEmpty ? "Unknown" : names.joined(separator: ", ")
    }
    
    var currencyText : String {
        let names = country.currencies?.values.compactMap { $0.name } ?? []
        return names.isEmpty ? "Unknown" : names.sorted().joined(separator: ", ")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: URL(string: country.flags?.png ?? "")) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "flag.slash")
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .padding(.top)
                
                Text(country.name.common)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let official = country.name.official {
                    Text(official)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                info("Capital", country.capital?.joined(separator: ", ") ?? "None")
                info("Region", country.region ?? "Unknown")
                info("Subregion", country.subregion ?? "Unknown")
                info("Population", country.population.map { $0.formatted() } ?? "Unknown")
                info("Area", country.area.map { "\($0.formatted()) km²" } ?? "Unknown")
                info("Languages", languageText)
                info("Currencies", currencyText)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Country Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func info(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.subheadline)
        }
    }
}

#Preview {
    CountryDetailView(country: Country(
        cca3: "COL",
        name: CountryName(
            common: "Colombia",
            official: "Republic of Colombia"
        ),
        capital: ["Bogotá"],
        region: "Americas",
        subregion: "South America",
        population: 50882884,
        area: 1141748.0,
        flags: Flags(png: "https://flagcdn.com/w320/co.png"),
        languages: ["spa": "Spanish"],
        currencies: ["COP": Currency(name: "Colombian peso")]
    ))
}
