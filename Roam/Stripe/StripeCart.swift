//
//  StripeCart.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/24/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation

var StripeCart = _StripeCart()

class _StripeCart {

    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    
    // change to 5% of subtotal?
    private var ourFee: Int = 50
    
    var deliveryFee: Int {
        if cartItems.count == 0 { return 0 }
        return 250
    }
    var subtotal: Int {
        var amount = 0  
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees : Int {
        if subtotal == 0 { return 0 }
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents + ourFee
        return feesAndSub
    }
    
    var total: Int {
        return subtotal + processingFees + deliveryFee
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
        print("\n")
        for item in cartItems {
            print(item.name, ", " ,item.description)
        }
        print("\n")
    }
    
    // TODO: double check that this check works
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(where: { $0 == item }) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
     func penniesToFormattedCurrency(numberInPennies: Int) -> String {
        
        let dollars = Double(numberInPennies) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}
