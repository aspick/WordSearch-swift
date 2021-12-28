//
//  TokenFilter.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

protocol TokenFilter {
    func filter(_ tokens: TokenStream) -> TokenStream
}
