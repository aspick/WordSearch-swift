//
//  Sorter.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/30.
//

import Foundation

protocol Sorter {
    func sort(documents: [Document], invertedIndex: InvertedIndex, tokens: [Token]) -> [Document]
}
