//
//  Notificaiton.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/11/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import UIKit

struct MyNotification {
    
    var userInfo: [AnyHashable : Any]
    
    var id: String { return self.userInfo["notificationId"] as? String ?? "no id"}
    var userEmail: String { return self.userInfo["userEmail"] as? String ?? "no email"}
    var locationName: String { return self.userInfo["locationName"] as? String ?? "no location"}
    var date: Date { return self.userInfo["date"] as? Date ?? Date()}

    init(userInfo: [AnyHashable : Any]) {
        self.userInfo = userInfo
        self.userInfo["date"] = Date()
    }
    
    init(customerEmail: String, customerUserName: String, locationName: String, notificationId: String) {
        let userInfo: [AnyHashable: Any] = [
            "userEmail": customerEmail,
            "locationName": locationName,
            "notificationId": notificationId,
            "date": Date()
        ]
        
        self.userInfo = userInfo
    }
    
    // i probably font need this function
    func modelToData(notification: MyNotification) -> [AnyHashable: Any] {
        let data : [String: Any] = [
            "userEmail": notification.userEmail,
            "locationName": notification.locationName,
            "notificationId": notification.id,
            "date": notification.date
        ]

        return data
    }
    
    
    func createAlert() -> UIAlertController {
        switch self.id {
        case "RequestToRoam":
            let message = "Looks like \(userInfo["userUserName"] as? String ?? "Name not found.") would like food delivered to \(userInfo["locationName"] as? String ?? "Location's Name Not Found.") \n Would you like to accept this delivery? "

            let alert = UIAlertController(title: "New Roam Request!", message: message, preferredStyle: .alert)

            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                print("action cancel handler")
            })
            
            alert.addAction(cancel)
            return alert
            
        default:
            print("Id not found, could not create alert.")
            return UIAlertController()
        }
    }
}
