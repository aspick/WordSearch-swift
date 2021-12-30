//
//  SearcherTest.swift
//  WordSearchTest
//
//  Created by Yugo TERADA on 2021/12/30.
//

import XCTest

class SearcherTest: XCTestCase {
    class TestStorage: Storage {
        let documents: [Document]
        let invertedIndex: InvertedIndex
        let tokens: [Token]
        
        init(documents: [Document], invertedIndex: InvertedIndex, tokens: [Token]) {
            self.documents = documents
            self.invertedIndex = invertedIndex
            self.tokens = tokens
        }
        
        func addDocument(_ document: Document) -> DocumentID { 0 }
        func upsertInvertedIndex(_ invertedIndex: InvertedIndex) {}
        func upsertToken(_ token: Token) -> TokenID { 0 }
        
        func getDocuments(_ documentIds: [DocumentID]) -> [Document] {
            self.documents.filter { doc in
                documentIds.contains(doc.id)
            }
        }
        
        func getInvertedIndexByTokenIDs(tokenIDs: [TokenID]) -> InvertedIndex {
            self.invertedIndex
                .filter { elem in
                    tokenIDs.contains(elem.key)
                }
        }
        
        
        func getTokensByTerms(_ terms: [String]) -> [Token] {
            self.tokens
                .filter { token in
                    terms.contains(token.term)
                }
                .sorted { tokenA, tokenB in
                    terms.firstIndex(of: tokenA.term)! < terms.firstIndex(of: tokenB.term)!
                }
        }
    }
    
    var testStorage: Storage!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testStorage = TestStorage(
            documents: [
                Document(id: 1, body: "foo bar baz", tokenCount: 3),
                Document(id: 2, body: "apple orange grapes", tokenCount: 3),
                Document(id: 3, body: "one two three", tokenCount: 3),
                Document(id: 4, body: "apple one", tokenCount: 2),
                Document(id: 5, body: "foo bar orange", tokenCount: 3)
                
            ],
            invertedIndex: [
                1: PostingList(postings: [
                    Postings(documentId: 1, positions: [0]),
                    Postings(documentId: 5, positions: [0])
                ]),
                2: PostingList(postings: [
                    Postings(documentId: 1, positions: [1]),
                    Postings(documentId: 5, positions: [1])
                ]),
                3: PostingList(postings: [
                    Postings(documentId: 1, positions: [2])
                ]),
                4: PostingList(postings: [
                    Postings(documentId: 2, positions: [0]),
                    Postings(documentId: 4, positions: [0])
                ]),
                5: PostingList(postings: [
                    Postings(documentId: 2, positions: [1]),
                    Postings(documentId: 5, positions: [2])
                ]),
                6: PostingList(postings: [
                    Postings(documentId: 2, positions: [2])
                ]),
                7: PostingList(postings: [
                    Postings(documentId: 3, positions: [0]),
                    Postings(documentId: 4, positions: [2])
                ]),
                8: PostingList(postings: [
                    Postings(documentId: 3, positions: [1])
                ]),
                9: PostingList(postings: [
                    Postings(documentId: 3, positions: [2])
                ])
            ],
            tokens: [
                Token(id: 1, term: "foo", kana: ""),
                Token(id: 2, term: "bar", kana: ""),
                Token(id: 3, term: "baz", kana: ""),
                Token(id: 4, term: "apple", kana: ""),
                Token(id: 5, term: "orange", kana: ""),
                Token(id: 6, term: "grapes", kana: ""),
                Token(id: 7, term: "one", kana: ""),
                Token(id: 8, term: "two", kana: ""),
                Token(id: 9, term: "three", kana: "")
            ]
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAndMatches() throws {
        try testAndMatch(query: ["apple", "orange"], expectedDocIds: [2])
        try testAndMatch(query: ["orange"], expectedDocIds: [2, 5])
        try testAndMatch(query: ["three", "two", "one"], expectedDocIds: [3])
    }
    
    
    func testAndMatch(query: [String], expectedDocIds: [DocumentID]) throws {
        let searcher = MatchSearcher.init(
            tokenStream: query.map({ term in Token(id: 0, term: term, kana: "")}),
            logic: .and,
            storage: testStorage,
            sorter: nil)
        
        assert(searcher.search().map({ $0.id}) == expectedDocIds)
    }
    
    func testOrMatches() throws {
        try testOrMatch(query: ["apple", "orange"], expectedDocIds: [2, 4, 5])
    }
    
    func testOrMatch(query: [String], expectedDocIds: [DocumentID]) throws {
        let searcher = MatchSearcher.init(
            tokenStream: query.map({ term in Token(id: 0, term: term, kana: "")}),
            logic: .or,
            storage: testStorage,
            sorter: nil)
        
        assert(searcher.search().map({ $0.id}) == expectedDocIds)
    }
    
    func testPhraseSearches() throws {
        try testPhraseSearch(query: ["apple", "orange"], expectedDocIds: [2])
        try testPhraseSearch(query: ["orange", "apple"], expectedDocIds: [])
    }
    
    func testPhraseSearch(query: [String], expectedDocIds: [DocumentID]) throws {
        let searcher = PhraseSearcher.init(
            tokenStream: query.map({ term in Token(id: 0, term: term, kana: "")}),
            storage: testStorage,
            sorter: nil)
        
        assert(searcher.search().map({ $0.id}) == expectedDocIds)
    }
}
