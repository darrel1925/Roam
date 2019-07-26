//
//  Product.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/24/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation

class Product: Equatable {
    var price: Double!
    var name: String!
    var amountOrdered: Int!
    var description: String?
    
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return (lhs.price == rhs.price) &&
               (lhs.name == rhs.name) &&
               (lhs.description == rhs.description) &&
               (lhs.amountOrdered == rhs.amountOrdered)
    }
    
    // TODO: how do I made description optional?
    init(name: String, price: Double, amountOrdered: Int, description: String?){
        self.name = name
        self.price = price
        self.amountOrdered = amountOrdered
        self.description = description ?? ""  
    }
    
    init(name: String, price: Double, amountOrdered: Int){
        self.name = name
        self.price = price
        self.amountOrdered = amountOrdered
        self.description = ""
    }
// ~~~ NEXT make sure you can add things to the car correctly
}
