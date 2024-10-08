//
//  AudioManger.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import Foundation
import OggDecoder
import AVFoundation


/// Class to mange all our audio stuff for playing the Pokémon's Cries / Sounds
class AudioManager {
    static let shared = AudioManager()
    private var player: AVPlayer?

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    
    /// Play the Pokemon cry, this version prefers the latest version of the cry over legacy (TODO: - make this a setting for the user)
    /// - Parameters:
    ///   - legacyUrl: URL associated with the ogg file with the legacy cry of the Pokemon
    ///   - latestUrl: URL associated with the ogg file with the latest version of the cry of the Pokemon
    func playPokemonCry(legacyUrl: String?, latestUrl: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let urlString = latestUrl ?? legacyUrl, let url = URL(string: urlString) else {
                Log.shared.error("No valid URL for the cry sound.")
                return
            }
            self?.downloadAndPlay(url: url)
        }
    }
    
    
    /// Function to dowload and play the ogg file which are the Pokémon's cries
    /// - Parameter url: URL to use
    private func downloadAndPlay(url: URL) {
        let localUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)

        // Check if the file already exists locally
        if FileManager.default.fileExists(atPath: localUrl.path) {
            Log.shared.info("We've already downloaded the file before, we'll use the local copy!")
            self.decodeOGGFile(at: localUrl)
        } else {
            // If file does not exist, download it
            let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
                guard let tempLocalUrl = tempLocalUrl, error == nil else {
                    Log.shared.error("Failed to download file: \(error?.localizedDescription ?? "No error information.")")
                    return
                }
                do {
                    // Move downloaded file to the permanent location
                    try FileManager.default.moveItem(at: tempLocalUrl, to: localUrl)
                    self.decodeOGGFile(at: localUrl)
                    Log.shared.info("Sound file deownloaded as ogg, now we will decode it!")
                } catch {
                    Log.shared.error("File handling error: \(error)")
                }
            }
            task.resume()
        }
    }

    /// Use the OggDecoder dependency to covert to a format we can play on iOS
    /// - Parameter localUrl: the local URL where the file to be decoded is currently stored
    private func decodeOGGFile(at localUrl: URL) {
        let decoder = OGGDecoder()
        decoder.decode(localUrl) { savedWavUrl in
            guard let savedWavUrl = savedWavUrl else {
                Log.shared.error("Failed to convert .ogg file.")
                return
            }
            Log.shared.info("The sound file has been decoded, now we play it!")
            self.setupPlayback(with: savedWavUrl)
        }
    }

    
    /// Setup the audio playback session, using shared instance, and set playback mode etc
    /// - Parameter url: local URL of decoded audio file for playback
    private func setupPlayback(with url: URL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            player = AVPlayer(url: url)
            player?.play()
        } catch {
            Log.shared.error("Failed to set up audio session: \(error)")
        }
    }
}
