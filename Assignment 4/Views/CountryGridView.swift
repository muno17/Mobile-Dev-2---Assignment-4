//
//  CountryListView.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import SwiftUI

struct CountryGridView: View {
    
    @Environment(CountriesViewModel.self) var viewModel
    @State var searchText = ""
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var filteredCountries : [Country] {
        if searchText.isEmpty {
            return viewModel.countries
        }
        return viewModel.countries.filter {
            $0.name.common.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading Countries...")
                        .padding()
                } else if filteredCountries.isEmpty {
                    VStack(spacing: 12) {
                        Text("No countries found.")
                            .multilineTextAlignment(.center)
                        Button("Try Again") {
                            Task { await viewModel.fetchCountries() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                VStack(spacing: 8) {
                                    AsyncImage(url: URL(string: country.flags?.png ?? "")) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFit()
                                        } else if phase.error != nil {
                                            Image(systemName: "flag.slash")
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(height: 80)
                                    
                                    Text(country.name.common)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(country.capital?.first ?? "No capital")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Countries")
            .searchable(text: $searchText, prompt: "Search countries")
        }
        .task {
            await viewModel.fetchCountries()
        }
        .alert("Something went wrong", isPresented: $viewModel.hasError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    CountryGridView()
        .environment(CountriesViewModel())
}
