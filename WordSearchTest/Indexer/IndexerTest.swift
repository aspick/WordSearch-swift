//
//  IndexerTest.swift
//  WordSearchTest
//
//  Created by Yugo TERADA on 2021/12/28.
//

import XCTest

class IndexerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if FileManager.default.fileExists(atPath: SQLiteDatabase.dbFilePath()) {
            try FileManager.default.removeItem(atPath: SQLiteDatabase.dbFilePath())
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let indexer = Indexer(
            storage: SQLiteStorage(),
            analyzer: Analyzer(
                charFilters: [MappingCharFilter(replacement: ["foo": "bar"])],
                tokenizer: MorphologicalTokenizer(),
                tokenFilters: [LowercaseFilter(), StopWordFilter(stopWords: ["を", "の", "i"])]),
            invertedIndex: InvertedIndex(),
            indexSizeThreashold: 10)
        
        let document = Document(id: 0, body: "this is the first document message", tokenCount: 6)
        indexer.addDocument(doc: document)
        
        assert(indexer.invertedIndex.keys.count == 6)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
