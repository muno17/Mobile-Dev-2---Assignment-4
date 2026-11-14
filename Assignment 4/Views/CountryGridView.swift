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
    @State var selectedRegion = "All"
    
    let regions = ["All", "Africa", "Americas", "Asia", "Europe", "Oceania", "Antarctic"]
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var filteredCountries : [Country] {
        viewModel.countries.filter { country in
            let matchesRegion = selectedRegion == "All" || country.region == selectedRegion
            let matchesSearch = searchText.isEmpty
                || country.name.common.localizedCaseInsensitiveContains(searchText)
            return matchesRegion && matchesSearch
        }
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(regions, id: \.self) { region in
                            Button {
                                selectedRegion = region
                            } label: {
                                Text(region)
                                    .font(.subheadline.weight(.medium))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedRegion == region ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(selectedRegion == region ? Color.white : Color.primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Loading Countries...")
                            .padding()
                    } else if filteredCountries.isEmpty {
                        VStack(spacing: 12) {
                            if viewModel.countries.isEmpty {
                                Text("Couldn't load countries.")
                                    .multilineTextAlignment(.center)
                                Button("Try Again") {
                                    Task { await viewModel.fetchCountries() }
                                }
                                .buttonStyle(.borderedProminent)
                            } else {
                                Text("No countries match your search.")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredCountries) { country in
                                NavigationLink(destination: CountryDetailView(country: country)) {
                                    VStack(spacing: 8) {
                                        AsyncImage(url: country.flagURL(width: 160)) { phase in
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
