//
//  AsyncImage.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import Nuke
import SwiftUI

/// We use a nice dependecy called Nuke here that automatically deals with caching images based on URLs to avoid
/// any repeated requests etc
struct CustomAsyncImage<Placeholder: View>: View {
    let url: URL
    private let placeholder: Placeholder
    @State private var uiImage: UIImage? = nil
    @State private var opacity = 0.0  // State to handle opacity for animation

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        self.url = url
    }

    var body: some View {
        ZStack {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .opacity(opacity)  // Apply dynamic opacity
                    .onAppear {
                        withAnimation(.easeIn(duration: Constants.UI.imageFadeInTime)) {
                            opacity = 1.0
                        }
                    }
            } else {
                placeholder
            }
        }
        .onAppear { load(url) }
        .onChange(of: url) { load($0) }
    }

    private func load(_ url: URL) {
        ImagePipeline.shared.loadImage(with: url) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.uiImage = response.image
                }
            case .failure:
                break  
            }
        }
    }
}



