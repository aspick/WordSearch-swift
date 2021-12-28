//
//  Tokenizer.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

protocol Tokenizer {
    func tokentize(_ string: String) -> TokenStream
}
