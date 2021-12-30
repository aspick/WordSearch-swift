//
//  Searcher.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/30.
//

import Foundation

protocol Searcher {
    func search() -> [Document] // TODO: throwable
}
