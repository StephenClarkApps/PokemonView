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
            .font(.system(.body, design: .default))
    }
}
