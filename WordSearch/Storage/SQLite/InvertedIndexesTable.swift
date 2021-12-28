//
//  InvertedIndexesTable.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/28.
//

import Foundation
import SQLite

class InvertedIndexesTable {
    let db: Connection
    
    let invertedIndexes = Table("inverted_indexes")
    let tokenId = Expression<Int64>("token_id")
    let postingList = Expression<String>("posting_list")
    
    let tokens = Table("tokens")
    let idOfToken = Expression<Int64>("id")
    
    init(_ db: Connection) {
        self.db = db
        migrate()
    }
    
    private func migrate() {
        do {
            try db.run(invertedIndexes.create(ifNotExists: true) { t in
                t.column(tokenId, primaryKey: true)
                t.column(postingList)
                
                t.foreignKey(tokenId, references: tokens, idOfToken, delete: .cascade)
            })
        } catch {
            debugPrint(error)
        }
    }
    
    func upsert(_ invertedIndex: InvertedIndex){
        do {
            try db.transaction {
                for (aTokenId, aPostingList) in invertedIndex {
                    let upsert = invertedIndexes.upsert(tokenId <- aTokenId, postingList <- aPostingList.toJson() , onConflictOf: tokenId)
                    try db.run(upsert)
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func whereWithTokenIds(_ tokenIds: [TokenID]) -> InvertedIndex {
        let query = invertedIndexes.filter(tokenIds.contains(tokenId))
        var invertedIndex = InvertedIndex()
        do {
            for row in try db.prepare(query) {
                invertedIndex[row[tokenId]] = PostingList.fromJson(row[postingList])
            }
        } catch {
            debugPrint(error)
        }
        return invertedIndex
    }
}
