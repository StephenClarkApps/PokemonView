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
                        HStack {
                            Spacer()
                            Button(action: {
                                // Define the action to perform when the image is tapped
                                print("Pokemon image tapped")
                            }) {
                                AsyncImage(url: URL(string: details.sprites.frontDefault)) {
                                    image in image.resizable()
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
                        // Frame adjustments
                        .frame(width: horizontalSizeClass == .compact ? geometry.size.width * 0.95 : geometry.size.width * 0.6,
                               height: horizontalSizeClass == .compact ? (geometry.size.width * 0.95) / 1.4 : (geometry.size.width * 0.6) / 1.4)
                        .background(Color.white.opacity(0.35)) // Semi-transparent background
                        .border(Color.pokemonFrameGold, width: 10) // Gold border akin to some kinds of trading card
                        .cornerRadius(10)
                        .padding(10)
                    }

                    
                    
                    // Button to play cry
                    Button("Hear My Cry!") {
                        AudioManager.shared.playPokemonCry(legacyUrl: details.cries.legacy, latestUrl: details.cries.latest)
                    }
                    .padding()
                    .background(Color("ColorBlueAdaptive"))
                    .foregroundColor(Color("ColorOtherAdaptiveYellow"))
                    .cornerRadius(8)
                    .accessibilityLabel("Hear it's cry!")
                    
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
                                .accessibilityLabel("This Pokemon has the type: \(type.type.name)")
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
                .frame(maxWidth: 500, maxHeight: 900) // Max dimensions for iPad purposes
                .background(
                    Group {
                        if colorScheme == .dark {
                            Image("background_dark") // Image for dark mode
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Image("background") // Image for light mode
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .accessibilityHidden(true) // Hides the background image from accessibility tools
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
