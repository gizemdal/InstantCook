//
//  Recipe.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/20/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import Foundation

struct Recipe {
    var title: String
    var id: Int
    var image: String
    var usedCount: Int
    var missingCount: Int
    
    init(title: String, id: Int, image: String, used: Int, missing: Int) {
        self.title = title
        self.id = id
        self.image = image
        self.usedCount = used
        self.missingCount = missing
    }
    
    mutating func getTitle() -> String {
        return title
    }
    
    mutating func getId() -> Int {
        return id
    }
    
    mutating func getImage() -> String {
        return image
    }
    
    mutating func getUsedCount() -> Int {
        return usedCount
    }
    
    mutating func getMissingCount() -> Int {
        return missingCount
    }
    
}
