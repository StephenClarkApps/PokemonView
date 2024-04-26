//
//  DefaultBlackText.swift
//  PokemonView
//
//  Created by Stephen Clark on 25/04/2024.
//

import SwiftUI

struct AdaptiveText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary) // Adjusts automatically to light/dark mode
            .scaledFont(name: "GillSans", size: 20) // Automatically adjust size if needed
            .fontWeight(.regular)
    }
}
