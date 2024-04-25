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

    func playPokemonCry(legacyUrl: String?, latestUrl: String?) {
        guard let urlString = legacyUrl ?? latestUrl, let url = URL(string: urlString) else {
            print("No valid URL for the cry sound.")
            return
        }
        downloadAndPlay(url: url)
    }

    private func downloadAndPlay(url: URL) {
        let localUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                print("Failed to download file: \(error?.localizedDescription ?? "No error information.")")
                return
            }
            do {
                if FileManager.default.fileExists(atPath: localUrl.path) {
                    try FileManager.default.removeItem(at: localUrl)
                }
                try FileManager.default.moveItem(at: tempLocalUrl, to: localUrl)
                self.decodeOGGFile(at: localUrl)
            } catch {
                print("File handling error: \(error)")
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
            self.setupPlayback(with: savedWavUrl)
        }
    }

    private func setupPlayback(with url: URL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            player = AVPlayer(url: url)
            player?.play()
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
}
