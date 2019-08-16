//
//  Notificaiton.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/11/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import UIKit

struct MyNotification: Equatable {
    
    var userInfo: [String : Any]
    
    var notificationId: String { return self.userInfo["notificationId"] as? String ?? "no id"}
    var senderEmail: String { return self.userInfo["userEmail"] as? String ?? "no email"}
    var senderUsername: String { return self.userInfo["userEmail"] as? String ?? "no email"}
    var locationName: String { return self.userInfo["locationName"] as? String ?? "no location"}
    var date: Date!

    init(userInfo: [String : Any]) {
        self.userInfo = userInfo
        
        let dateStr = userInfo["date"] as! String
        print("date is", userInfo["date"], "then" , dateStr.toDate())
        self.date = dateStr.toDate()
    }
    
    init(senderEmail: String, senderUsername: String, locationName: String, notificationId: String) {
        let userInfo: [String: Any] = [
            "senderEmail": senderEmail,
            "senderUsername": senderUsername,
            "locationName": locationName,
            "notificationId": notificationId,
            "date": Date()
        ]
        self.userInfo = userInfo
    }
    
    // i probably font need this function
    func modelToData(notification: MyNotification) -> [String: Any] {
        let data : [String: Any] = [
            "senderEmail": notification.senderEmail,
            "senderUsername": senderUsername,
            "locationName": notification.locationName,
            "notificationId": notification.notificationId,
            "date": notification.date
        ]

        return data
    }
    
    
    func createAlert() -> UIAlertController {
        switch self.notificationId {
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
    
    func formatId() -> String {
        switch self.notificationId {
        case "RequestToRoam":
            return "Request To Roam"
        default:
            return "New Notification"
        }
    }
    
    func formatMessage() -> String {
        switch self.notificationId {
        case "RequestToRoam":
            return "\(UserService.user.firstName) would like you to deliver Panda express to \(locationName) within 25 minutes."
        default:
            return "New Message"
        }
    }
    
    static func == (lhs: MyNotification, rhs: MyNotification) -> Bool {
        return (lhs.notificationId == rhs.notificationId) &&
            (lhs.senderEmail == rhs.senderEmail) &&
            (lhs.senderUsername == rhs.senderUsername) &&
            (lhs.locationName == rhs.locationName) &&
            (lhs.date == rhs.date)
    }
}
