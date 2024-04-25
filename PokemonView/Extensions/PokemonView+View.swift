//
//  PokemonView+View.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import SwiftUI

extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        self.modifier(ScaledFont(name: name, size: size))
    }
}
