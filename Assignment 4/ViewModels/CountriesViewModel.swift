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
        
        let urlString = "https://restcountries.com/v3.1/all?fields=name,cca3,capital,region,subregion,population,area,flags,languages,currencies"
        
        guard let url = URL(string: urlString) else { return }
        
        self.isLoading = true
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder().decode([Country].self, from: data)
            self.countries = decoded.sorted { $0.name.common < $1.name.common }
            self.isLoading = false
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.hasError = true
            self.isLoading = false
        }
    }
}
