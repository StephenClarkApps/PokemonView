//
//  ScaledFont.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import SwiftUI

/// Custom adaptive font sizing based on users iOS settings
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}
