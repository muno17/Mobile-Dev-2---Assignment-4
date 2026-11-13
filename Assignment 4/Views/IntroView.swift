//
//  IntroView.swift
//  Assignment 4
//
//  Created by Danny Muñoz on 11/13/26.
//

import SwiftUI

struct IntroPage : Identifiable {
    let systemImage : String
    let caption : String
    var id : String { caption }
}

struct IntroView: View {
    
    var onFinish : () -> Void = { }
    
    let pages = [
        IntroPage(systemImage: "globe.americas.fill",
                  caption: "Explore countries from around the world"),
        IntroPage(systemImage: "magnifyingglass",
                  caption: "Search by name to find any country fast"),
        IntroPage(systemImage: "flag.fill",
                  caption: "See flags, capitals, population, languages, and more")
    ]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(pages) { page in
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: page.systemImage)
                            .font(.system(size: 120))
                            .foregroundStyle(.blue)
                        
                        Text(page.caption)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .padding()
            
            Button(action: {
                onFinish()
            }) {
                Text("Start Exploring")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    IntroView()
}
