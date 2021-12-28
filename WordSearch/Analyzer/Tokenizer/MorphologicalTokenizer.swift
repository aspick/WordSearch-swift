//
//  MorphologicalTokenizer.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation
import NaturalLanguage

class MorphologicalTokenizer: Tokenizer {
    let tokenizer = NLTokenizer(unit: .word)
    
    func tokentize(_ string: String) -> TokenStream {
        var tokenStream = TokenStream()
        tokenizer.string = string
        tokenizer.enumerateTokens(in: (string.startIndex..<string.endIndex)) { wordRange, attr in
            
            tokenStream.append(
                Token(id: 0, term: String(string[wordRange]), kana: "")
            )
            
            return true
        }
        
        return tokenStream
    }
}
