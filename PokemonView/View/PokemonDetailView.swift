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
    
    var body: some View {
        Group {
            if let details = viewModel.pokemonDetail {
                VStack(alignment: .center, spacing: 25) {
                    // Pokémon ID and name at the top (like on the playing cards)
                    HStack {
                        Text(details.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .accessibilityAddTraits(.isHeader)  
                            .accessibilityLabel("Pokémon name: \(details.name)")
                        
                        Spacer()
                        
                        Text("HP \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "--")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .accessibilityLabel("Health Points: \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "unknown")")
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Pokémon Image
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: details.sprites.frontDefault)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 220, height: 220)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .accessibilityLabel("Image of Pokémon \(details.name)")
                        Spacer()
                    }
                    
                    // Button to play cry
                    Button("Hear My Cry!") {
                        playPokemonCry(legacyUrl: details.cries.legacy, latestUrl: details.cries.latest)
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
                .background(Color.white)
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

    
    
    /// Function to play the cry of the Pokemon
    /// Because the backend only provides an ogg file we actually need to pull in a dependency and download and covert it to play it
    ///
    func playPokemonCry(legacyUrl: String?, latestUrl: String?) {
        // Determine which URL to use, prefer legacy but fall back to latest if necessary
        guard let urlString = legacyUrl ?? latestUrl, let url = URL(string: urlString) else {
            print("No valid URL for the cry sound.")
            return
        }
        
        // Your existing download and playback logic
        downloadAndPlay(url: url)
    }
    
    func downloadAndPlay(url: URL) {
        // Setup the file path in local storage
        let localUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    // If the file already exists, remove it
                    if FileManager.default.fileExists(atPath: localUrl.path) {
                        try FileManager.default.removeItem(at: localUrl)
                    }
                    try FileManager.default.moveItem(at: tempLocalUrl, to: localUrl)
                    // Decode the downloaded .ogg file
                    self.decodeOGGFile(at: localUrl)
                } catch {
                    print("File handling error: \(error)")
                }
            } else {
                print("Failed to download file: \(error?.localizedDescription ?? "No error information.")")
            }
        }
        task.resume()
    }
    
    private func decodeOGGFile(at localUrl: URL) {
        let decoder = OGGDecoder()
        decoder.decode(localUrl) { savedWavUrl in
            guard let savedWavUrl = savedWavUrl else {
                print("Failed to convert .ogg file.")
                return
            }
            
            // Setup audio session for playback
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
                // Create a player instance and play the file
                self.player = AVPlayer(url: savedWavUrl)
                self.player?.play()
            } catch {
                print("Failed to set up audio session: \(error)")
            }
        }
    }
    
}

// MARK: - PREVIEW
#Preview {
    PokemonDetailView(viewModel: PokemonDetailViewModel(apiManager: APIManager()), pokemonURL: "https://pokeapi.co/api/v2/pokemon/1/")
}
