//
//  PokemonView+String.swift
//  PokemonView
//
//  Created by Stephen Clark on 26/04/2024.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
