//
//  Untitled.swift
//  MovieQuiz
//
//  Created by Andrey Sopov on 06.02.2025.
//

import Foundation
import XCTest

@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        let array: [Int] = [1, 1, 2, 3, 5]
        let value = array[safe: 2]
        
        XCTAssertEqual(value, 2)
        XCTAssertNotNil(value)
    }
    
    func testGetValueOutOfRange() throws {
        
        let array: [Int] = [1, 1, 2, 3, 5]
        let value = array[safe: 20]
        
        XCTAssertNil(value)
        
    }
}
