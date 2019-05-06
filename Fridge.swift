//
//  Fridge.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/17/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import Foundation

struct Fridge {
    var ingredients : [(String, String)]
    var numOfIngredients : Int
    
    init() {
        ingredients = []
        numOfIngredients = 0
    }
    mutating func getIngredients() -> [(String, String)] {
        return ingredients
    }
    mutating func getSize() -> Int {
        return numOfIngredients
    }
    mutating func addIngredient(newIng: (String, String)) {
        ingredients.append(newIng)
        numOfIngredients = numOfIngredients + 1
    }
    
    mutating func resetIngredients() {
        ingredients = []
        numOfIngredients = 0
    }
}
