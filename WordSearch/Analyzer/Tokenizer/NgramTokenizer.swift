//
//  NgramTokenizer.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

class NgramTokenizer: Tokenizer {
    let n: Int
    
    init(_ n: Int) {
        self.n = n
    }
    
    func tokentize(_ string: String) -> TokenStream {
        let count = (string.count + 1 - n)
        var tempTokens = TokenStream()
        
        for i in 0..<count {
            let startIndex = string.index(string.startIndex, offsetBy: i)
            let endIndex = string.index(string.startIndex, offsetBy: i + n)
            tempTokens.append(
                Token(id: 0, term: String(string[startIndex..<endIndex]), kana: "")
            )
        }
        
        return tempTokens
    }
}
