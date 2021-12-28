//
//  Indexer.swift
//  WordSearch
//
//  Created by Yugo TERADA on 2021/12/27.
//

import Foundation

class Indexer {
    let storage: Storage
    let analyer: Analyzer
    var invertedIndex: InvertedIndex
    let indexSizeThreashold: Int
    
    init(storage: Storage, analyzer: Analyzer, invertedIndex: InvertedIndex, indexSizeThreashold: Int) {
        self.storage = storage
        self.analyer = analyzer
        self.invertedIndex = invertedIndex
        self.indexSizeThreashold = indexSizeThreashold
    }
    
    func addDocument(doc: Document) {
        var tempDoc = doc
        let tokens = analyer.analyze(doc.body)
        tempDoc.tokenCount = tokens.count
        
        let docId = storage.addDocument(tempDoc)
        tempDoc.id = docId
        
        updateMemoryInvertedIndexByDocument(docId: docId, tokens: tokens)
        
        if invertedIndex.count < indexSizeThreashold { return }
        
        let storageInvertedIndex = storage.getInvertedIndexByTokenIDs(tokenIDs: invertedIndex.tokenIDs())
        
        for (tokenId, postingList) in invertedIndex {
            postingList.merge(storageInvertedIndex[tokenId])
        }
        
        storage.upsertInvertedIndex(invertedIndex)
        
        invertedIndex = InvertedIndex()
        return
    }
    
    private func updateMemoryPostingListByToken(docId: DocumentID, token: Token, pos: Int) {
        let tokenId = storage.upsertToken(token)
        
        guard let postingList = invertedIndex[tokenId] else {
            invertedIndex[tokenId] = PostingList(postings: [Postings(documentId: docId, positions: [pos])])
            return
        }

        let existedPosting = postingList.postings.first(where: { posting in
            posting.documentId == docId
        })
        if var existedPosting = existedPosting {
            existedPosting.positions.append(pos)
            return
        }
        
        postingList.postings.append(Postings(documentId: docId, positions: [pos]))
    }
    
    private func updateMemoryInvertedIndexByDocument(docId: DocumentID, tokens: TokenStream) {
        tokens.enumerated().forEach { (index, token) in
            updateMemoryPostingListByToken(docId: docId, token: token, pos: index)
        }
    }
}
