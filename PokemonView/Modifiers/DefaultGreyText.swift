//
//  DefaultGreyText.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI


/// View modifiers are a good way to de-deplcate and standardise code with SwiftUI
struct DefaultGreyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.gray)
            .font(.system(.body, design: .default))
    }
}
