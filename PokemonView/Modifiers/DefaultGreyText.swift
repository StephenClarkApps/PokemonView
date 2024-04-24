//
//  DefaultGreyText.swift
//  PokemonView
//
//  Created by Stephen Clark on 24/04/2024.
//

import SwiftUI

struct DefaultGreyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.gray)
            .font(.system(.body, design: .default))
    }
}
