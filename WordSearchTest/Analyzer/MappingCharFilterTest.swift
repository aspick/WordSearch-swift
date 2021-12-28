//
//  MappingCharFilterTest.swift
//  WordSearch-swiftTest
//
//  Created by Yugo TERADA on 2021/12/26.
//

import XCTest

class MappingCharFilterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let filter = MappingCharFilter(replacement:["foo":"bar"])
        
        assert(filter.filter("this is foo message") == "this is bar message")
    }

}
