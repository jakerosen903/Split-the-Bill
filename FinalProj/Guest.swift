//
//  Guest.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/2/21.
//

import Foundation

class Guest {
    
    var name: String
    var owe: Float
    var foods: [Food]
    
    init(name: String) {
        self.name = name
        self.owe = 0.0
        self.foods = []
    }
    
    func addFood(food: Food) {
        foods.append(food)
    }
    
    func removeFood(food: Food) {
        var count:Int = 0
        for i in foods {
            if i === food {
                foods.remove(at: count)
                break
            }
            count += 1
        }
    }
}
