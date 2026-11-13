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
    var isLoading = false
    var hasError = false
    var errorMessage = ""
    
    @MainActor
    func fetchCountries() async {
        guard countries.isEmpty else { return }
         
        // Live public mirror endpoint containing the full country dataset array
        let urlString = "https://raw.githubusercontent.com/mledoze/countries/master/countries.json"
         
        guard let url = URL(string: urlString) else { return }
         
        self.isLoading = true
         
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
             
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                throw URLError(.badServerResponse)
            }
             
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Country].self, from: data)
            
            // Sort alphabetically and update state
            self.countries = decoded.sorted { $0.name.common < $1.name.common }
            self.isLoading = false
             
        } catch {
            print("FULL DECODING ERROR: \(error)")
            self.errorMessage = error.localizedDescription
            self.hasError = true
            self.isLoading = false
        }
    }
}
