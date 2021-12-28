//
//  SQLiteStorage.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/28.
//

import Foundation

class SQLiteStorage: Storage {
    var db: SQLiteDatabase
    
    init() {
        db = SQLiteDatabase()
    }
    
    
    func addDocument(_ document: Document) -> DocumentID {
        db.documents.insert(document)
    }
    
    func getInvertedIndexByTokenIDs(tokenIDs: [TokenID]) -> InvertedIndex {
        db.invertedIndexes.whereWithTokenIds(tokenIDs)
    }
    
    func upsertInvertedIndex(_ invertedIndex: InvertedIndex) {
        db.invertedIndexes.upsert(invertedIndex)
    }
    
    func upsertToken(_ token: Token) -> TokenID {
        db.tokens.upsert(token)
    }
    
    
}
