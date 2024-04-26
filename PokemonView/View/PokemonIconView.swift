//
//  PokemonIconView.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import Foundation
import SwiftUI

struct PokemonTypeIcon: View {
    var typeName: String
    var color: Color
    var iconName: String
    @State private var isPressed = false


    var body: some View {
        VStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(20)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 0)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .contentShape(Circle())
                            .scaleEffect(isPressed ? 1.1 : 1.0)
                            .animation(.easeInOut, value: isPressed)
                            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                                withAnimation {
                                    isPressed = pressing
                                }
                            }, perform: {})
            
            Text(typeName)
                .scaledFont(name: "GillSans", size: 18)
                .fontWeight(.semibold)
                .foregroundColor(Color("ColorTextAdaptive"))
        } //: VSTACK
        .contentShape(Circle())
        .accessibilityLabel("\(typeName) type")
    }
}


// Example Usage in a View
struct PokemonTypeIconsView: View {
    var body: some View {
        HStack {
            PokemonTypeIcon(typeName: "Fire", color: Color("fireColor"), iconName: "fire")
            PokemonTypeIcon(typeName: "Water", color: Color("waterColor"), iconName: "water")
        }
    }
}

#Preview {
    PokemonTypeIconsView()
}
