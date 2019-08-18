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
    var senderEmail: String { return self.userInfo["senderEmail"] as? String ?? "no email"}
    var senderUsername: String { return self.userInfo["senderUsername"] as? String ?? "no username"}
    var senderFCMToken: String { return self.userInfo["senderFCMToken"] as? String ?? "no FCMToken"}
    var locationName: String { return self.userInfo["locationName"] as? String ?? "no location"}
    var isActive: String = "true"
    var date: Date!
    var longitude: String { return self.userInfo["longitude"] as? String ?? "0" }
    var latitude: String { return self.userInfo["latitude"] as? String ?? "0" }


    init(userInfo: [String : Any]) {
        self.userInfo = userInfo
        convertDateToString()
    }
    
    private mutating func convertDateToString() {
        let dateStr = userInfo["date"] as! String
        print("date is", userInfo["date"], "then" , dateStr.toDate())
        self.date = dateStr.toDate()
    }
    
    func modelToData() -> [String: Any] {
        print("lat", self.latitude, "lon", self.longitude)
        let data : [String: Any] = [
            "notificationId": self.notificationId,
            "senderEmail": self.senderEmail,
            "senderUsername": self.senderUsername,
            "senderFCMToken": self.senderFCMToken,
            "locationName": self.locationName,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "isActive": "true",
            "date": self.date.toString()
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
            (lhs.date == rhs.date)
    }
}
