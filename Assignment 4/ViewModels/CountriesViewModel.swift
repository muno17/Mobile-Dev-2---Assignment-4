//
//  CountriesViewModel.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import SwiftUI

@Observable
class CountriesViewModel {
    var countries : [Country] = []
    var isLoading = true
    var hasError = false
    var errorMessage = ""
    
    @MainActor
    func fetchCountries() async {
        guard countries.isEmpty else { return }
        
        let urlString = "https://raw.githubusercontent.com/mledoze/countries/master/countries.json"
        
        guard let url = URL(string: urlString) else { return }
        
        self.isLoading = true
        
        // Start the population request at the same time as the countries request
        async let populationsTask = fetchPopulations()
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                throw URLError(.badServerResponse)
            }
            
            var decoded = try JSONDecoder().decode([Country].self, from: data)
            
            // Merge population in by 3-letter country code
            let populations = await populationsTask
            for index in decoded.indices {
                decoded[index].population = populations[decoded[index].cca3]
            }
            
            self.countries = decoded.sorted {
                $0.name.common.localizedCompare($1.name.common) == .orderedAscending
            }
            self.isLoading = false
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.hasError = true
            self.isLoading = false
        }
    }
    
    // Returns [country code : population]. If anything fails, returns an
    // empty dictionary so the app still works without population.
    func fetchPopulations() async -> [String : Int] {
        let urlString = "https://api.worldbank.org/v2/country/all/indicator/SP.POP.TOTL?format=json&per_page=2000&date=2022:2025"
        
        guard let url = URL(string: urlString) else { return [:] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PopulationResponse.self, from: data)
            
            // Keep the most recent year that has a value for each country
            var latest : [String : (year: Int, value: Int)] = [:]
            
            for row in response.rows {
                guard let code = row.countryiso3code, !code.isEmpty,
                      let value = row.value,
                      let year = Int(row.date) else { continue }
                
                if let existing = latest[code], existing.year >= year { continue }
                latest[code] = (year, Int(value))
            }
            
            return latest.mapValues { $0.value }
        } catch {
            return [:]
        }
    }
}
