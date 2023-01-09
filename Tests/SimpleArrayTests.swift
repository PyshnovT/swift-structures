//
//  data_structuresTests.swift
//  data-structuresTests
//
//  Created by Tim Pyshnov on 9.01.2023.
//

import XCTest
@testable import data_structures

class SimpleArrayTests: XCTestCase {

    func testArray() {
        let arr = SimpleArray<Int>(minimumCapacity: 10)
        XCTAssertTrue(arr.isEmpty)
    }
    
}
