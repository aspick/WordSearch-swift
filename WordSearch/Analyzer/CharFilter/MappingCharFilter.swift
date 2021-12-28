//
//  MappingCharFilter.swift
//  WordSearch-swift
//
//  Created by Yugo TERADA on 2021/12/26.
//

import Foundation

class MappingCharFilter: CharFilter {
    let replacement: Dictionary<String, String>
    
    init(replacement: Dictionary<String, String>) {
        self.replacement = replacement
    }
    
    func filter(_ source: String) -> String {
        var tempSource = source
        
        replacement.forEach({ (key: String, value: String) in
            tempSource = tempSource.replacingOccurrences(of: key, with: value)
        })
        
        return tempSource
    }
    
}
