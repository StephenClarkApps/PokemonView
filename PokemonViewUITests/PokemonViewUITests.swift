//
//  PokemonViewUITests.swift
//  PokemonViewUITests
//
//  Created by Stephen Clark on 22/04/2024.
//

import XCTest

final class PokemonViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_whenTappingBetweenTabs_AppWorksAsExpected() throws {
        
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        tabBar.buttons["About"].tap()
        tabBar.buttons["Pokemon"].tap()
    }
    
    func test_TappingIntoPokemonDetailsScreen_ShowPokemonDetailsScreen() throws {
                
        // Open the detail view
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Bulbasaur"]/*[[".cells.staticTexts[\"Bulbasaur\"]",".staticTexts[\"Bulbasaur\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
}



