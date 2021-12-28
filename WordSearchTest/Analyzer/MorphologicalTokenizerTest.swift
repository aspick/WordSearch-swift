//
//  MorphologicalTokenizerTest.swift
//  WordSearchTest
//
//  Created by Yugo TERADA on 2021/12/26.
//

import XCTest

class MorphologicalTokenizerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let tokenizer = MorphologicalTokenizer()
        
        let sampleMessage = "今日の天気は晴れです"
        let expectedTokens = ["今日", "の", "天気", "は", "晴れ", "です"]
        let actualTokens = tokenizer.tokentize(sampleMessage).map { token in token.term }
        assert(actualTokens == expectedTokens)
    }

}
