//
//  DocumentsTable.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/28.
//

import Foundation
import SQLite

let documents = Table("documents")
let id = Expression<Int64>("id")
let body = Expression<String>("body")
let tokenCount = Expression<Int>("token_count")

class DocumentsTable {
    let db: Connection
    
    init(_ db: Connection) {
        self.db = db
        migration()
    }
    
    private func migration() {
        do {
            try db.run(documents.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(body)
                t.column(tokenCount)
            })
        } catch {
            debugPrint(error)
        }
    }
    
    func insert(_ doc: Document) -> DocumentID {
        let insert = documents.insert(body <- doc.body, tokenCount <- doc.tokenCount)
        
        do {
            let rowId = try db.run(insert)
            let document = try db.pluck(documents.filter(id == rowId))
            return document![id]
        } catch {
            debugPrint(error)
        }
        
        return 0
    }
    
    func findBy(id docId: DocumentID) -> Document? {
        do {
            let row = try db.pluck(documents.filter(docId == id))
            guard let row = row else { return nil }

            return Document(id: row[id], body: row[body], tokenCount: row[tokenCount])
        } catch {
            debugPrint(error)
        }
        return nil
    }
}
