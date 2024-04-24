//
//  PokemonViewTests.swift
//  PokemonViewTests
//
//  Created by Stephen Clark on 22/04/2024.
//

import XCTest
import Combine
@testable import PokemonView

class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!
    var mockAPIManager: MockAPIManager!
    var cancellables: Set<AnyCancellable> = []  // Store subscriptions in test cases.

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = PokemonListViewModel(apiManager: mockAPIManager)
    }
    
    // MARK: - FETCHING & DECODING DATA TESTS

    // Mock Test
    func testFetchPokemonList_ShouldFetchList() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Fetch Pokemon List")
        expectation.expectedFulfillmentCount = 1  // Expect to fulfill once

        // Register to receive updates. You expect 20 items from your mock.
        var cancellable: AnyCancellable?
        cancellable = viewModel.$pokemonList
            .sink(receiveValue: { pokemonList in
                if !pokemonList.isEmpty {
                    XCTAssertEqual(pokemonList.count, 20, "Expected 20 Pokemon to be fetched")
                    expectation.fulfill()
                }
            })

        // WHEN
        viewModel.fetchPokemonList()

        // THEN
        wait(for: [expectation], timeout: 5.0)
        cancellable?.cancel()
    }

    // Mock Test
    func testFetchPokemonDetails_ShouldGivePokemonDetails() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Fetch Pokemon Details")
        expectation.expectedFulfillmentCount = 1  // Expect to fulfill once

        // WHEN
        let url = "https://pokeapi.co/api/v2/pokemon/1/"
        viewModel.fetchAndStorePokemonDetails(url: url)

        // THEN
        var cancellable: AnyCancellable?
        cancellable = viewModel.$pokemonDetails
            .sink(receiveValue: { pokemonDetails in
                if let details = pokemonDetails {
                    XCTAssertEqual(details.name, "bulbasaur", "Expected to receive details for Bulbasaur")
                    expectation.fulfill()
                }
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable?.cancel()
    }

    // MARK: SEARCH TESTS
    func testSearchPokemon_FiltersListCorrectly() {
        // GIVEN
        let expectation = XCTestExpectation(description: "Pokemon list filtered")
        let expectedFilteredNames = ["bulbasaur"]  // Assuming your mock includes at least "bulbasaur"

        // Setup initial list
        viewModel.pokemonList = [
            IndividualPokemon(name: "bulbasaur", url: "url1"),
            IndividualPokemon(name: "ivysaur", url: "url2")
        ]

        // WHEN
        viewModel.searchPokemon(name: "bulba")

        // THEN
        XCTAssertEqual(viewModel.filteredPokemon.count, 1, "Should only contain one Pokémon matching 'bulba'")
        XCTAssertEqual(viewModel.filteredPokemon.first?.name, expectedFilteredNames.first, "Filtered Pokémon should be 'bulbasaur'")
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

}

