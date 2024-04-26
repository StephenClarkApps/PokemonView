//
//  AboutView.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI

struct AboutView: View {
    // MARK: - PROPERTIES
  
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // MARK: - HEADER
            VStack(alignment: .center, spacing: 5) {
                Image("pokemonLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.top)
                    .frame(width: 200, height: 100, alignment: .center)
                    .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                
                Text("View")
                    .scaledFont(name: "GillSans", size: 30)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ColorYellowAdaptive"))
                    .padding(.top, -10)
            } //: VSTACK
            .accessibilityLabel("Pokémon View App Logo")
            .padding()
            
            Form {
                // MARK: - ABOUT SECTION
                Section(header: Text("About the App")) {
                    HStack {
                        Text("Version").modifier(DefaultGreyText())
                        Spacer()
                        Text("1.0.0")
                    }.accessibilityLabel("Version 1.0.0")

                    HStack {
                        Text("Developer").modifier(DefaultGreyText())
                        Spacer()
                        Text("Stephen Clark")
                    }.accessibilityLabel("Developer. Stephen Clark")
                    HStack {
                        Text("Credits").modifier(DefaultGreyText())
                        Spacer()
                        Text("Data provided by PokéAPI")
                    }.accessibilityLabel("Credits. Data provided by PokéAPI")
                    HStack {
                        VStack {
                            Spacer()
                            HStack {
                                Text("Legal").modifier(DefaultGreyText())
                                
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Text("All Pokémon content is © Nintendo, Game Freak, and The Pokémon Company.").multilineTextAlignment(.leading)
                                    .font(.system(.body, design: .default))
                                Spacer()
                            }
                        }.accessibilityLabel("Legal Text. All Pokémon content is © Nintendo, Game Freak, and The Pokémon Company.")
                    }
                } //: FROM SECTION
                
                // MARK: - LINKS SECTION
                Section(header: Text("API Details")) {
                    HStack {
                        Text("API Site").modifier(DefaultGreyText())
                        Spacer()
                        Link("Visit PokéAPI", destination: URL(string: "https://pokeapi.co")!)
                            .accessibilityLabel("Link to Visit PokéAPI for information about the API used")
                    }
                } //: FORM SECTION
            }//: FORM
        }
        .frame(maxWidth: 640)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
