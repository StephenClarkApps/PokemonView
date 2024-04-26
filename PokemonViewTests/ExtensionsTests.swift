//
//  ExtensionsTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 26/04/2024.
//

import XCTest
import Combine
import SwiftUI
@testable import PokemonView

class ExtensionsTests: XCTestCase {
    
    
    func test_PokemonFrameGoldColor_CreatedCorrectly() {
        // GIVEN
        let color = Color.pokemonFrameGold
        // WHEN / THEN
        XCTAssertEqual(color.description, "#D4963859")
    }
    
    func test_CapitalizingFirstLetterExtension_BehavesCorrectly() {
        // GIVEN
        let originalString = "hello world"
        // WHEN
        let capitalizedString = originalString.capitalizingFirstLetter()
        // THEN
        XCTAssertEqual(capitalizedString, "Hello world")
    }
}
