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
    private var ourFee: Int = 60
    
    var isEmpty: Bool {
        return cartItems.count == 0
    }
    
    var tax: Int {
        let tax = Double(subtotal) * 0.08
        let taxInPennies = Int(tax)
        print("tax in pennies", taxInPennies)
        return taxInPennies
    }
    
    var deliveryFee: Int {
        if cartItems.count == 0 { return 0 }
        return 300
    }
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * Double(item.amountOrdered) * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees : Int {
        if subtotal == 0 { return 0 }
        let sub = Double(subtotal)
        let feesAndSub = Int((sub + Double(tax)) * stripeCreditCardCut) + flatFeeCents + ourFee
        print("processing fees", feesAndSub)
        return feesAndSub
    }
    
    var total: Int {
        return subtotal + processingFees + deliveryFee + tax
    }
    
    var count: Int {
        var totalCount = 0
        for item in cartItems {
            totalCount += item.amountOrdered
        }
        return totalCount
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
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

