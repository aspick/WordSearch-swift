//
//  LowercaseFilter.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

class LowercaseFilter: TokenFilter {
    func filter(_ tokens: TokenStream) -> TokenStream {
        return tokens.map { token in
            Token(id: token.id, term: token.term.lowercased(), kana: token.kana)
        }
    }
}
