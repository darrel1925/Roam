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
    var senderFirstName: String { return self.userInfo["senderFirstName"] as? String ?? "no firstName"}
    var senderLastName: String { return self.userInfo["senderLastName"] as? String ?? "no lastName"}
    var senderFCMToken: String { return self.userInfo["senderFCMToken"] as? String ?? "no FCMToken"}
    var locationName: String { return self.userInfo["locationName"] as? String ?? "no location"}
    var longitude: String { return self.userInfo["longitude"] as? String ?? "0" }
    var latitude: String { return self.userInfo["latitude"] as? String ?? "0" }
    var isActive: String = "true"
    var date: Date!


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
            "senderFirstName": self.senderFirstName,
            "senderLastName": self.senderLastName,
            "senderFCMToken": self.senderFCMToken,
            "locationName": self.locationName,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "isActive": "true",
            "date": self.date.toString()
        ]

        return data
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
            return "\(UserService.user.firstName) \(UserService.user.lastName)  would like you to deliver Panda express to \(locationName) within 25 minutes."
        default:
            return "New Message"
        }
    }
    
    static func == (lhs: MyNotification, rhs: MyNotification) -> Bool {
        return (lhs.notificationId == rhs.notificationId) &&
            (lhs.senderEmail == rhs.senderEmail) &&
            (lhs.senderFirstName == rhs.senderFirstName) &&
            (lhs.senderLastName == rhs.senderLastName) &&
            (lhs.date == rhs.date)
    }
}
