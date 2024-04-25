//
//  PokemonDetailView.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI
import Foundation
import OggDecoder
import AVFoundation

struct PokemonDetailView: View {
    
    // MARK: - PROPERTIES
    @ObservedObject var viewModel: PokemonDetailViewModel
    let pokemonURL: String
    @State private var player: AVPlayer?
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    @State private var pulsateAnimation: Bool = false
    
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
                            .foregroundColor(.black)
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityLabel("Pokémon name: \(details.name.capitalizingFirstLetter())")

                        Spacer()
                        
                        // The HP Section (I'm trying to style this like the trading cards)
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("HP")
                                .scaledFont(name: "Ariel", size: 15)
                                .fontWeight(.black)
                                .foregroundColor(.black)

                            Text(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "--")
                                .scaledFont(name: "GillSans", size: 40)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .accessibilityLabel("Health Points: \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "unknown")")
                        
                    }
                    .padding(.horizontal)
                    
                    // Pokémon Image
                    GeometryReader { geometry in
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: details.sprites.frontDefault)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .shadow(color: .gray, radius: 10, x: 5, y: 5)
                            .scaleEffect(self.pulsateAnimation ? 1.1 : 0.95)
                            .opacity(self.pulsateAnimation ? 1 : 0.8)
                            .animation(Animation.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: pulsateAnimation)
                            .accessibilityLabel("Image of Pokémon \(details.name)")
                            .onAppear {
                                self.pulsateAnimation.toggle() // Start the animation
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width * 0.95, height: (geometry.size.width * 0.95) / 1.4)
                        .background(Color.white.opacity(0.35)) // Applying semi-transparent background
                        .border(Color.gold, width: 10) // Gold border like a trading card
                        .cornerRadius(10)
                        .padding(10) // Minimal padding to maintain the aspect ratio
                    }

                    
                    // Button to play cry
                    Button("Hear My Cry!") {
                        AudioManager.shared.playPokemonCry(legacyUrl: details.cries.legacy, latestUrl: details.cries.latest)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel("Tap to hear the Pokémon cry")
                    
                    // Type badges
                    HStack {
                        Spacer()
                        ForEach(details.types, id: \.slot) { type in
                            Text(type.type.name.capitalized)
                                .font(.caption)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .accessibilityLabel("\(type.type.name) type")
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .accessibilityElement(children: .combine)

              

                    // Flavor text
                    Text("Flavor text goes here")
                        .font(.caption)
                        .italic()
                        .padding()
                        .foregroundColor(.gray)
                        .accessibilityLabel("Flavor text: Flavor text goes here")

                    Spacer()
                }
                .frame(maxWidth: 500, maxHeight: 900) // Mac dims for iPad purposes
                .background(
                  Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                )
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
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
