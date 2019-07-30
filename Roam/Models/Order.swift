//
//  Order.swift
//  Roam
//
//  Created by Darrel Muonekwu on 6/16/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//
import Foundation

struct Order: Codable {
    
    var itemNames = [[String:String]]()
    
    var itemExtras = [[String]]()
    
    static func getOrder() -> Order {
        let defaults = UserDefaults.standard
        guard let orderData = defaults.object(forKey: "order") as? Data else {
            // couldn't retrieved the order
            return Order()
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let order = try? PropertyListDecoder().decode(Order.self, from: orderData) else {
            // couldn't retrieved the order
            return Order()
        }
        // order was successfuly retrieved
        return order
    }
    
    static func setOrder(order: Order) {
        // save new order to user defaults
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(order), forKey: "order")
    }
}
