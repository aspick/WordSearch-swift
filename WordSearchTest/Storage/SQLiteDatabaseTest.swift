//
//  SQLiteDatabaseTest.swift
//  WordSearchTest
//
//  Created by Yugo TERADA on 2021/12/28.
//

import XCTest

class SQLiteDatabaseTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if FileManager.default.fileExists(atPath: SQLiteDatabase.dbFilePath()) {
            try FileManager.default.removeItem(atPath: SQLiteDatabase.dbFilePath())
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInstantiate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        _ = SQLiteDatabase()
    }
    
    func testCreateDocument() throws {
        let db = SQLiteDatabase()
        let doc = Document(id: 0, body: "test document string", tokenCount: 3)
        let docId = db.documents.insert(doc)
        assert(docId > 0)
        
        let savedDoc = db.documents.findBy(id: docId)
        assert(savedDoc != nil)
        assert(savedDoc?.id == docId)
        assert(savedDoc?.body == doc.body)
        assert(savedDoc?.tokenCount == doc.tokenCount)
    }
    
    func testCreateToken() throws {
        let db = SQLiteDatabase()
        let token = Token(id: 0, term: "保険", kana: "")
        let tokenId = db.tokens.upsert(token)
        assert(tokenId > 0)
        
        let savedToken = db.tokens.findBy(id: tokenId)
        assert(savedToken != nil)
        assert(savedToken?.id == tokenId)
        assert(savedToken?.term == token.term)
        assert(savedToken?.kana == token.kana)
        
        let savedTokens = db.tokens.whereBy(terms: ["保険"])
        assert(savedTokens.count == 1)
        assert(savedTokens.first?.id == savedToken?.id)
    }
    
    func testCreateInvertedIndexes() throws {
        let db = SQLiteDatabase()
        let invertedIndex: InvertedIndex = [
            1: PostingList(postings: [
                Postings(documentId: 1, positions: [1,2,3]),
                Postings(documentId: 2, positions: [2,4])
            ]),
            2: PostingList(postings: [
                Postings(documentId: 3, positions: [5,10,20])
            ])
        ]
        db.invertedIndexes.upsert(invertedIndex)
        
        let savedInvertedIndex = db.invertedIndexes.whereWithTokenIds([1])
        assert(!savedInvertedIndex.isEmpty)
        assert(savedInvertedIndex[1] != nil)
        assert(savedInvertedIndex[1]!.postings.count == 2)
        assert(savedInvertedIndex[1]?.postings.first?.documentId == 1)
        assert(savedInvertedIndex[1]?.postings.first?.positions == [1,2,3])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
