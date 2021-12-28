//
//  StopWordFilter.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

class StopWordFilter: TokenFilter {
    let stopWords: [String]
    
    init(stopWords: [String]) {
        self.stopWords = stopWords
    }
    
    func filter(_ tokens: TokenStream) -> TokenStream {
        tokens.filter { token in
            return !stopWords.contains(token.term)
        }
    }
}
