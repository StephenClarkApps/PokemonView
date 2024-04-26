//
//  PokemonDetailView.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI
import Foundation

struct PokemonDetailView: View {
    
    // MARK: - PROPERTIES
    
    @ObservedObject var viewModel: PokemonDetailViewModel
    let pokemonURL: String
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    @State private var pulsateAnimation: Bool = false
    
    // Environment properties to handle device orientation
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        Group {
            if let details = viewModel.pokemonDetail {
                VStack(alignment: .center, spacing: 10) {
                    Spacer().frame(height: 8)
                    // Pokémon ID and name at the top (like on the playing cards)
                    HStack {
                        Text(details.name.capitalizingFirstLetter())
                            .scaledFont(name: "GillSans", size: 30)
                            .fontWeight(.bold)
                            .foregroundColor(Color("ColorTextAdaptive"))
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityLabel("Pokémon name: \(details.name.capitalizingFirstLetter())")

                        Spacer()
                        
                        // The HP Section (I'm trying to style this like the trading cards)
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("HP")
                                .scaledFont(name: "Ariel", size: 15)
                                .foregroundColor(Color("ColorTextAdaptive"))
                                .foregroundColor(.white)

                            Text(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "--")
                                .scaledFont(name: "GillSans", size: 40)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("ColorTextAdaptive"))
                        }
                        .accessibilityLabel("Health Points: \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "unknown")")
                        
                    }
                    .padding(.horizontal)
                    
                    // Pokémon Image
                    GeometryReader { geometry in
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Pokemon image tapped")
                                }) {
                                    AsyncImage(url: URL(string: details.sprites.frontDefault)) { image in
                                        image.resizable()
                                             .aspectRatio(contentMode: .fit)
                                    }
                                    placeholder: {
                                        ProgressView()
                                    }
                                }
                                .shadow(color: .gray, radius: 10, x: 5, y: 5)
                                .scaleEffect(self.pulsateAnimation ? 1.1 : 0.95)
                                .opacity(self.pulsateAnimation ? 1 : 0.8)
                                .animation(Animation.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: pulsateAnimation)
                                .accessibilityLabel("An Image of Selected Pokémon, with the number \(details.id) Which is called: \(details.name)")
                                .onAppear {
                                    self.pulsateAnimation.toggle() // Start the animation
                                }
                                Spacer()
                            }
                            .frame(width: horizontalSizeClass == .compact ? geometry.size.width * 0.95 : geometry.size.width * 0.6,
                                   height: horizontalSizeClass == .compact ? (geometry.size.width * 0.95) / 1.4 : (geometry.size.width * 0.6) / 1.4)
                            .background(Color.white.opacity(0.35)) // Semi-transparent background
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)), lineWidth: 6)
                            )
                            .padding(10)
                        }
                    } //: GEOMETRY READER
                    


                    // Type badges using icons
                    HStack {
                        Spacer()
                        ForEach(details.types, id: \.slot) { type in
                            PokemonTypeIcon(typeName: type.type.name.capitalized, color: Color("\(type.type.name)Color"), iconName: "\(type.type.name)")
                                .accessibilityLabel("\(type.type.name.capitalized) type")
                        }
                        Spacer()
                    }
                    .padding()
                    .border(Color.gray, width: 3.0)
                    .cornerRadius(3.0)
                    .padding(.horizontal)
                    .accessibilityElement(children: .combine)
                    
                    // Button to play cry
                    Button("Hear My Cry!") {
                        AudioManager.shared.playPokemonCry(legacyUrl: details.cries.legacy, latestUrl: details.cries.latest)
                    }
                    .padding()
                    .background(Color("ColorBlueAdaptive"))
                    .foregroundColor(Color("ColorOtherAdaptiveYellow"))
                    .cornerRadius(8)
                    .accessibilityLabel("Hear it's cry!")
                    

              

                    // Flavor text
                    Text("Flavor text goes here")
                        .font(.caption)
                        .italic()
                        .padding()
                        .foregroundColor(.gray)
                        .accessibilityLabel("Flavor text: Flavor text goes here")

                    Spacer()
                }
                .frame(maxWidth: 500, maxHeight: 900) // Max dimensions for iPad purposes
                .border(Color.brown, width: 2) // Border Like a Card border
                .cornerRadius(5)
                .shadow(radius: 5)
                .padding()
            } else {
                Text("Loading...")
                    .accessibilityLabel("Loading Pokémon details")
                    .onAppear {
                        viewModel.loadPokemonDetails(from: pokemonURL)
                    }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: APIManager()), pokemonURL: "https://pokeapi.co/api/v2/pokemon/1/")
}
