//
//  CountryDetailView.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import SwiftUI
import MapKit

struct CountryDetailView: View {
    
    var country : Country
    
    var capitalText : String {
        let names = country.capital ?? []
        return names.isEmpty ? "None" : names.joined(separator: ", ")
    }
    
    var languageText : String {
        let names = country.languages?.values.sorted() ?? []
        return names.isEmpty ? "Unknown" : names.joined(separator: ", ")
    }
    
    var currencyText : String {
        let names = country.currencies?.values.compactMap { $0.name } ?? []
        return names.isEmpty ? "Unknown" : names.sorted().joined(separator: ", ")
    }
    
    var coordinate : CLLocationCoordinate2D? {
        guard let latlng = country.latlng, latlng.count == 2 else { return nil }
        return CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: country.flagURL(width: 640)) { phase in
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
                
                VStack(alignment: .leading, spacing: 15) {
                    info("Capital", capitalText)
                    info("Region", nonEmpty(country.region))
                    info("Subregion", nonEmpty(country.subregion))
                    info("Area", country.area.map { "\($0.formatted()) km²" } ?? "Unknown")
                    info("Population", country.population.map { $0.formatted() } ?? "Unknown")
                    info("Languages", languageText)
                    info("Currencies", currencyText)
                    info("UN Member", yesNo(country.unMember))
                    info("Landlocked", yesNo(country.landlocked))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                if let coordinate = coordinate {
                    Text("Location")
                        .font(.headline)
                    
                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
                    ))) {
                        Marker(country.name.common, coordinate: coordinate)
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
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
    
    func nonEmpty(_ text: String?) -> String {
        if let text, !text.isEmpty { return text }
        return "Unknown"
    }
    
    func yesNo(_ value: Bool?) -> String {
        guard let value else { return "Unknown" }
        return value ? "Yes" : "No"
    }
}

#Preview {
    CountryDetailView(country: Country(
        cca3: "COL",
        cca2: "CO",
        name: CountryName(
            common: "Colombia",
            official: "Republic of Colombia"
        ),
        capital: ["Bogotá"],
        region: "Americas",
        subregion: "South America",
        population: 50_822_822,
        area: 1141748.0,
        landlocked: false,
        unMember: true,
        latlng: [4, -72],
        languages: ["spa": "Spanish"],
        currencies: ["COP": Currency(name: "Colombian peso", symbol: "$")]
    ))
}
