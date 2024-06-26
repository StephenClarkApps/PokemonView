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
    @ObservedObject var viewModel: PokemonDetailViewModel // injected from elsewhere so @ObservedObject
    let pokemonURL: String
    @State private var pulsateAnimation: Bool = false

    var body: some View {
        Group {
            if let details = viewModel.pokemonDetail {
                VStack(alignment: .center, spacing: 10) {
                    Spacer().frame(height: 8)
                    // Pokémon ID and name at the top (like on the playing cards)
                    HStack {
                        Text(details.name.capitalizingFirstLetter())
                            .scaledFont(name: "Gill Sans", size: 30)
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
                                .scaledFont(name: "Gill Sans", size: 40)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("ColorTextAdaptive"))
                        }
                        .accessibilityLabel("Health Points: \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "unknown")")
                        
                    }
                    .padding(.horizontal)
                    
                    // Pokémon Image
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                print("Pokemon image tapped - Sound will play")
                                
                                // PLAY SOUND
                                AudioManager.shared.playPokemonCry(legacyUrl: details.cries?.legacy ?? "", latestUrl: details.cries?.latest ?? "")
                                
                                // HAPTIC
                                let generator = UIImpactFeedbackGenerator(style: .rigid)
                                generator.impactOccurred()
                               
                            }) {
                                
                                CustomAsyncImage(url: URL(string: details.sprites?.frontDefault ?? "")!) {
                                    AnyView(Text("Loading...")  // Wrap the placeholder in AnyView
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10))
                                }
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .scaleEffect(self.pulsateAnimation ? 1.1 : 1.0) // Scale effect for animation
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                        self.pulsateAnimation = true
                                    }
                                }
                            }
                            .frame(width: 300, height: 214) // Set dimensions
                            .background(Color.white.opacity(0.35)) // Semi-transparent background
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 10, x: 5, y: 5)
                            .padding()
                            .accessibilityLabel("Pokemon Image, tap for sound")
                            Spacer()
                        }
                    }

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
                    

                    // Weight
                    Text("Weight: \(details.weight) hectograms")
                        .font(.caption)
                        .italic()
                        .padding(5)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Pokemon Weight is: \(details.weight) hectograms")
                    // Height
                    Text("Height: \(details.height) decimetres")
                        .font(.caption)
                        .italic()
                        .padding(5)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Pokemon Height is: \(details.height) decimetres")

                    Spacer()
                }
                .frame(maxWidth: 500, maxHeight: 900) // Max dimensions for iPad purposes
                .border(Color.gray, width: 3) // Border Like a Card border
                .cornerRadius(3)
                .shadow(radius:6)
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
let realmProviderX = DefaultRealmProvider()
let cacheManagerX = PokemonCacheManager(realmProvider: realmProviderX)
let apiManForPrevX = APIManager(cacheManager: cacheManager)
#Preview {

    PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: apiManForPrevX),
                      pokemonURL: "https://pokeapi.co/api/v2/pokemon/1/")
}
