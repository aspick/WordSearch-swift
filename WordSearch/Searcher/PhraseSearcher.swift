//
//  PhraseSearcher.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/30.
//

import Foundation

class PhraseSearcher: Searcher {
    let tokenStream: TokenStream
    let storage: Storage
    let sorter: Sorter?
    
    init(tokenStream: TokenStream, storage: Storage, sorter: Sorter?) {
        self.tokenStream = tokenStream
        self.storage = storage
        self.sorter = sorter
    }
    
    func search() -> [Document] {
        // validation
        
        let tokens = storage.getTokensByTerms(tokenStream.terms())
        
        let invertedIndex = storage.getInvertedIndexByTokenIDs(tokenIDs: tokens.map{ token in token.id })
        
        let postingLists = tokens.map { token in
            CursoredPostingList(postings: invertedIndex[token.id]!.postings)
        }
        
        var matchedIds: [DocumentID]
        matchedIds = phraseSearch(postingLists)
        
        let documents = storage.getDocuments(matchedIds)
        
        guard let sorter = sorter else {
            return documents
        }
        
        return sorter.sort(documents: documents, invertedIndex: invertedIndex, tokens: tokens)
    }
    
    private func phraseSearch(_ postingLists: [CursoredPostingList]) -> [DocumentID] {
        var ids = [DocumentID]()
        
        while(true) {
            if !postingLists.allSatisfy({ postingList in
                postingList.current() != nil
            }) { return ids }
            
            if postingLists.allSatisfy({ postingList in
                postingList.current()?.documentId == postingLists[0].current()?.documentId
            }) {
                
                if phraseMatched(tokenStream: tokenStream, postingLists: postingLists) {
                    ids.append(postingLists[0].current()!.documentId)
                    postingLists.forEach { postingLists in
                        postingLists.next()
                    }
                    continue
                }
            }
            
            let minList = postingLists.enumerated().min { listA, listB in
                listA.element.current()!.documentId < listB.element.current()!.documentId
            }
            minList?.element.next()
        }
        
        return ids
    }
    
    private func phraseMatched(tokenStream: TokenStream, postingLists: [CursoredPostingList]) -> Bool {
        let relativePositionSets = postingLists.enumerated().map { index, postingList in
            postingList.current()!.positions.map { $0 - index }
        }
        
        for relativePosition in relativePositionSets[0] {
            if relativePositionSets.allSatisfy({ positionSet in
                positionSet.contains(relativePosition)
            }) {
                return true
            }
        }

        return false
    }
}
