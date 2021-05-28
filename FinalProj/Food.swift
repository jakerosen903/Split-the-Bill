//
//  Food.swift
//  FinalProj
//
//  Created by Jason Talpalar on 4/2/21.
//

import Foundation

class Food {

    var name: String
    var price: Float
    var guests: [Guest]
    
    init(name: String, price: Float) {
        self.name = name
        self.price = price
        guests = []
    }
    
    func addGuest(guest: Guest) {
        guests.append(guest)
    }
    
    func removeGuest(guest: Guest) {
        var count:Int = 0
        for p in guests {
            if p === guest {
                guests.remove(at: count)
                break
            }
            count += 1
        }
    }
}
