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

    // FETCHING AND STORING POKEMON SPECIES
    func testFetchingPokemonSpecies_WorksCorrectly() {
        // Given
        let expectation = XCTestExpectation(description: "Pokemon species can be fetched and decoded correctly")
        let speciesId = 132  // Assuming this ID corresponds to the species in your mock JSON
        let mockSpecies = mockAPIManager.mockPokemonSpeciesResponse()

        // When
        viewModel.fetchPokemonSpecies(speciesId: speciesId)

        // Then
        viewModel.$pokemonSpecies
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed with error: \(error)")
                }
            }, receiveValue: { species in
                XCTAssertNotNil(species, "The fetched Pokemon species should not be nil")
                XCTAssertEqual(species?.id, mockSpecies.id, "The fetched species ID should match the mocked data ID")
                XCTAssertEqual(species?.name, mockSpecies.name, "The fetched species name should match the mocked data name")
                // More asserts can be added here based on other properties
                expectation.fulfill()
            })
            .store(in: &self.cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
        
}

