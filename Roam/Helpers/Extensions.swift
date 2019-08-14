//
//  Extensions.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/27/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseFirestore

extension UIViewController {
    
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func displayError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func displayError(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: completion)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        
        return dateFormatter.date(from: self) ?? Date()
    }
}


extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }

}

extension DispatchGroup {
    var count: Int {
        let count = self.debugDescription.components(separatedBy: ",").filter({$0.contains("count")}).first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap{Int($0)}.first
        return count!
    }
    
    func customLeave(){
        if count > 0 {
            self.leave()
        }
    }
}




