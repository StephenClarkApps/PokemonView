//
//  DefaultBlackText.swift
//  PokemonView
//
//  Created by Stephen Clark on 25/04/2024.
//

import SwiftUI

struct DefaultBlackText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.black)
            .font(.system(.body, design: .default))
    }
}
