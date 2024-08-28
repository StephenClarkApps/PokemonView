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
                contentView(details: details)
            } else {
                loadingView
                    .onAppear {
                        viewModel.loadPokemonDetails(from: pokemonURL)
                    }
            }
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        Text("Loading...")
            .accessibilityLabel("Loading Pokémon details")
    }

    // MARK: - Content View
    private func contentView(details: PokemonDetail) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Spacer().frame(height: 8)
            
            headerView(details: details)
            
            pokemonImageView(details: details)
            
            typeBadgesView(details: details)
            
            heightWeightView(details: details)
            
            Spacer()
        }
        .frame(maxWidth: 500, maxHeight: 900) // Max dimensions for iPad purposes
        .border(Color.gray, width: 3) // Border like a card
        .cornerRadius(3)
        .shadow(radius: 6)
        .padding()
    }

    // MARK: - Header View
    private func headerView(details: PokemonDetail) -> some View {
        HStack {
            Text(details.name.capitalizingFirstLetter())
                .scaledFont(name: "Gill Sans", size: 30)
                .fontWeight(.bold)
                .foregroundColor(Color("ColorTextAdaptive"))
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Pokémon name: \(details.name.capitalizingFirstLetter())")

            Spacer()
            
            hpView(details: details)
        }
        .padding(.horizontal)
    }

    // MARK: - HP View
    private func hpView(details: PokemonDetail) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text("HP")
                .scaledFont(name: "Ariel", size: 15)
                .foregroundColor(Color("ColorTextAdaptive"))

            Text(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "--")
                .scaledFont(name: "Gill Sans", size: 40)
                .fontWeight(.semibold)
                .foregroundColor(Color("ColorTextAdaptive"))
        }
        .accessibilityLabel("Health Points: \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "unknown")")
    }

    // MARK: - Pokemon Image View
    private func pokemonImageView(details: PokemonDetail) -> some View {
        HStack {
            Spacer()
            Button(action: {
                handlePokemonImageTap(details: details)
            }) {
                CustomAsyncImage(url: URL(string: details.sprites?.frontDefault ?? "")!) {
                    AnyView(Text("Loading...")
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10))
                }
                .aspectRatio(contentMode: .fit)
                .clipped()
                .scaleEffect(self.pulsateAnimation ? 1.1 : 1.0) // Scale effect for animation
                .onAppear {
                    startPulsateAnimation()
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

    // MARK: - Type Badges View
    private func typeBadgesView(details: PokemonDetail) -> some View {
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
    }

    // MARK: - Height & Weight View
    private func heightWeightView(details: PokemonDetail) -> some View {
        VStack {
            Text("Weight: \(details.weight) hectograms")
                .font(.caption)
                .italic()
                .padding(5)
                .foregroundColor(.gray)
                .accessibilityLabel("Pokemon Weight is: \(details.weight) hectograms")
            
            Text("Height: \(details.height) decimetres")
                .font(.caption)
                .italic()
                .padding(5)
                .foregroundColor(.gray)
                .accessibilityLabel("Pokemon Height is: \(details.height) decimetres")
        }
    }

    // MARK: - Actions
    private func handlePokemonImageTap(details: PokemonDetail) {
        Log.shared.debug("Pokemon image tapped - Sound will play")
        
        // Play sound
        AudioManager.shared.playPokemonCry(legacyUrl: details.cries?.legacy ?? "", latestUrl: details.cries?.latest ?? "")
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }

    // MARK: - Animation
    private func startPulsateAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            self.pulsateAnimation = true
        }
    }
}

// MARK: - PREVIEW
struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let realmProviderX = DefaultRealmProvider()
        let cacheManagerX = PokemonCacheManager(realmProvider: realmProviderX)
        let apiManagerX = APIManager(cacheManager: cacheManagerX)
        let viewModel = PokemonDetailViewModel(apiManager: apiManagerX)
        
        PokemonDetailView(viewModel: viewModel,
                          pokemonURL: "https://pokeapi.co/api/v2/pokemon/1/")
    }
}
