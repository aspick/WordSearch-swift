//
//  Analyzer.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

class Analyzer{
    let charFilters: [CharFilter]
    let tokenier: Tokenizer
    let tokenFilters: [TokenFilter]
    
    init (charFilters: [CharFilter], tokenizer: Tokenizer, tokenFilters: [TokenFilter]) {
        self.charFilters = charFilters
        self.tokenier = tokenizer
        self.tokenFilters = tokenFilters
    }
    
    func analyze(_ text: String) -> TokenStream {
        var tempText = text
        charFilters.forEach { filter in
            tempText = filter.filter(tempText)
        }
        
        var tokenStream = tokenier.tokentize(tempText)
        
        tokenFilters.forEach { filter in
            tokenStream = filter.filter(tokenStream)
        }
        
        return tokenStream
    }
}
