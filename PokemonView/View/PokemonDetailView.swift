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
                VStack(alignment: .leading, spacing: 10) {
                    // Pokémon ID and name at the top (like on the playing cards)
                    HStack {
                        Text(details.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("HP \(details.stats.first(where: { $0.stat.name == "hp" })?.baseStat.description ?? "--")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    } //: HStack
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    HStack {
                        Spacer()
                        // Pokémon Image
                        AsyncImage(url: URL(string: details.sprites.frontDefault)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 220, height: 220)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .onTapGesture {
                            playPokemonCry(from: details.cries.latest)
                        }
                        Spacer()
                    } //: HSTACK
                    
                    // Type badges
                    HStack {
                        ForEach(details.types, id: \.slot) { type in
                            Text(type.type.name.capitalized)
                                .font(.caption)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // TODO: - get teh "Flavor" text (what the pokemon says) somehow to show
                    Text("Flavor text goes here")
                        .font(.caption)
                        .italic()
                        .padding()
                        .foregroundColor(.gray)

                    Spacer()
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.loadPokemonDetails(from: pokemonURL)
                    }
            }
        }
    }
    
    /// Function to play the cry of the Pokemon
    /// Because the backend only provides an ogg file we actually need to pull in a dependency and download and covert it to play it
    ///
    func playPokemonCry(from urlString: String) {  // TODO: - Refactor out non view related or shared elements
           guard let remoteUrl = URL(string: urlString) else {
               print("Invalid URL")
               return
           }
           
           // Download the file to a local storage because, as far as I can tell the library needs this
           let localUrl = documentsDirectory.appendingPathComponent(remoteUrl.lastPathComponent)
           let task = URLSession.shared.downloadTask(with: remoteUrl) { tempLocalUrl, response, error in
               if let tempLocalUrl = tempLocalUrl, error == nil {
                   do {
                       // If the file already exists, remove it (or use caching if names are unique then unneeded I think)
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

    
    // MARK: - HELPER FUNCTIONS
    
    
    /// Function to decode OGG because AVFoundation doesn't suppor this out of the box as a playback format
    ///
    /// - Parameter localUrl: URL of presumably where a ogg has been downloaded to (or something)
       private func decodeOGGFile(at localUrl: URL) {
           
           // Create the decoder and then play the audio
           let decoder = OGGDecoder()
           decoder.decode(localUrl) { (savedWavUrl: URL?) in
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
