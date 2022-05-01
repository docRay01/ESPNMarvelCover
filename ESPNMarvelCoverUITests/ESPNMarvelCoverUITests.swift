//
//  ESPNMarvelCoverUITests.swift
//  ESPNMarvelCoverUITests
//
//  Created by Davis, R. Steven on 4/28/22.
//

import XCTest

class ESPNMarvelCoverUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testLoadIssue() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        //app.launchArguments = ["-ui-testing", "YES"]
        app.launch()
        
        let submitButton = app.buttons["submit button"]
        XCTAssert(submitButton.exists)
        
        let textInput = app.textFields["comicId field"]
        XCTAssert(textInput.exists)
        
        textInput.tap()
        textInput.typeText("356")
        submitButton.tap()
        
        // Quick and dirty test if the next view was loaded
        XCTAssert(app.images["Cover Art Image"].waitForExistence(timeout: 2.0))
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
