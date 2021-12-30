//
//  MatchSearcher.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/30.
//

import Foundation

enum Logic {
    case and
    case or
}

class MatchSearcher: Searcher {
    let tokenStream: TokenStream
    let logic: Logic
    let storage: Storage
    let sorter: Sorter?
    
    init(tokenStream: TokenStream, logic: Logic, storage: Storage, sorter: Sorter?) {
        self.tokenStream = tokenStream
        self.logic = logic
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
        switch logic {
        case .and:
            matchedIds = andMatch(postingLists)
        case .or:
            matchedIds = orMatch(postingLists)
        }
        
        let documents = storage.getDocuments(matchedIds)
        
        guard let sorter = sorter else {
            return documents
        }
        
        return sorter.sort(documents: documents, invertedIndex: invertedIndex, tokens: tokens)
        
    }
    
    private func andMatch(_ postingLists: [CursoredPostingList]) -> [DocumentID] {
        var ids = [DocumentID]()
        
        while(true) {
            if !postingLists.allSatisfy({ postingList in
                postingList.current() != nil
            }) { return ids }
            
            if postingLists.allSatisfy({ postingList in
                postingList.current()?.documentId == postingLists[0].current()?.documentId
            }) {
                ids.append(postingLists[0].current()!.documentId)
                postingLists.forEach { postingLists in
                    postingLists.next()
                }
            } else {
                let minList = postingLists.enumerated().min { listA, listB in
                    listA.element.current()!.documentId < listB.element.current()!.documentId
                }
                minList?.element.next()
            }
        }
        
        return ids
    }
  
    
    private func orMatch(_ postingLists: [CursoredPostingList]) -> [DocumentID] {
        return postingLists.flatMap { postingList in
            postingList.postings.map { posting in
                posting.documentId
            }
        }
    }
    
    
}
