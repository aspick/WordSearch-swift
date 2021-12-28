//
//  Document.swift
//  WordSearch
//
//  Created by Yugo TERADA on 2021/12/27.
//

import Foundation

typealias DocumentID = Int64

struct Document {
    var id: DocumentID
    let body: String
    var tokenCount: Int
}
