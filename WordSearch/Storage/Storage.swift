//
//  Storage.swift
//  WordSearch
//
//  Created by Yugo TERADA on 2021/12/27.
//

import Foundation

protocol Storage {
    func addDocument(_ document: Document) -> DocumentID
    func getInvertedIndexByTokenIDs(tokenIDs: [TokenID]) -> InvertedIndex
    func upsertInvertedIndex(_ invertedIndex: InvertedIndex)
    func upsertToken(_ token: Token) -> TokenID
}
