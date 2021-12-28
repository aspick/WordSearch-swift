//
//  InvertedIndex.swift
//  WordSearch
//
//  Created by Yugo TERADA on 2021/12/27.
//

import Foundation

struct Postings: Codable {
    let documentId: DocumentID
    var positions: [Int]
}

class PostingList: Codable {
    var postings: [Postings]
    
    init(postings: [Postings]) {
        self.postings = postings
    }
    
    func merge(_ anotherPostingList: PostingList?) {
        guard let anotherPostingList = anotherPostingList else { return }
 
        postings.append(contentsOf: anotherPostingList.postings)
    }
    
    func toJson() -> String {
        try! String(bytes: JSONEncoder.init().encode(self), encoding: .utf8)!
    }
    
    static func fromJson(_ json: String) -> Self {
        try! JSONDecoder.init().decode(self, from: json.data(using: .utf8)!)
    }
}

typealias InvertedIndex = Dictionary<TokenID, PostingList>

extension InvertedIndex {
    func tokenIDs() -> [TokenID] {
        [TokenID](self.keys)
    }
}
