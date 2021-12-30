//
//  Token.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

typealias TokenID = Int64

struct Token {
    let id: TokenID
    let term: String
    let kana: String
}

typealias TokenStream = [Token]

extension TokenStream {
    func terms() -> [String] {
        self.map { token in token.term }
    }
}
