//
//  TokensTable.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/28.
//

import Foundation
import SQLite

class TokensTable {
    let db: Connection
    
    let tokens = Table("tokens")
    let id = Expression<Int64>("id")
    let term = Expression<String>("term")
    let kana = Expression<String>("kana")
    
    init(_ db: Connection) {
        self.db = db
        migrate()
    }
    
    private func migrate() {
        do {
            try db.run(tokens.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(term, unique: true)
                t.column(kana)
            })
        } catch {
            debugPrint(error)
        }
    }
    
    func upsert(_ token: Token) -> Int64 {
        let upsert = tokens.upsert(term <- token.term, kana <- token.kana, onConflictOf: term)
//        let upsert = tokens.insert(term <- token.term, kana <- token.kana)
        
        do {
            let rowId = try db.run(upsert)
            let token = try db.pluck(tokens.filter(id == rowId))
            return token![id]
        } catch {
            debugPrint(error)
        }
        return 0
    }
    
    func findBy(id tokenId: TokenID) -> Token? {
        do {
            let row = try db.pluck(tokens.filter(tokenId == id))
            guard let row = row else { return nil }

            return Token(id: row[id], term: row[term], kana: row[kana])
        } catch {
            debugPrint(error)
        }
        return nil
    }
}
