//
//  SQLiteDatabase.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/28.
//

import Foundation
import SQLite

fileprivate let FILE_NAME = "storage.sqlite"

class SQLiteDatabase {
    private let db: Connection
    let documents: DocumentsTable
    let tokens: TokensTable
    let invertedIndexes: InvertedIndexesTable
    
    init() {
        db = try! Connection(Self.dbFilePath())
        
        documents = DocumentsTable(db)
        tokens = TokensTable(db)
        invertedIndexes = InvertedIndexesTable(db)
    }
    
    static func dbFilePath() -> String {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(FILE_NAME).path
    }
}
