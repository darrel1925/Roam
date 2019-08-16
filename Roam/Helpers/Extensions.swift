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
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)!
        
    }
}


extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toStringInWords() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let dateStr = dateFormatter.string(from: self)
        
        return formatMyDate(dateStr: dateStr)
    }
    
    private func formatMyDate(dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a" // "4:44 pm
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        let dateStr2 = formatter.string(from: self) // "4:44 PM on June 23, 2016\n"
        
        let dateArr = dateStr.components(separatedBy: ", ") // Wednesday, January 10, 2018

        return "\(dateArr[0]) • \(dateStr2)" // Wednesday • 4:44 pm
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




