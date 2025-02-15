//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Andrey Sopov on 06.02.2025.
//
import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testsAlert() {
        sleep(2)
        for _ in 0..<10{
            sleep(2)
            app.buttons["No"].tap()
        }
        let alert = app.alerts["Этот раунд окончен"]
        XCTAssertNotNil(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен")
        XCTAssertNotNil(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertClose() {
           sleep(2)
           for _ in 1...10 {
               app.buttons["No"].tap()
               sleep(2)
           }
           let alert = app.alerts["Этот раунд окончен"]
           sleep(2)
           XCTAssertNotNil(alert.exists)
           app.alerts.buttons.firstMatch.tap()
           sleep(2)
           XCTAssertFalse(alert.exists)
           let textLabel = app.staticTexts["Index"].label
           XCTAssertEqual(textLabel, "1/10")
       }
}
