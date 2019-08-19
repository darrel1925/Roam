//
//  NotificationService.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/11/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit

let NotificationService = _NotificationService()

class _NotificationService {
    
    var notifications: [MyNotification] = []
    var hasNotifications: Bool { return notifications.count > 0}
    var count: Int { return notifications.count}
    
    
    func addNotificaton(withData notif: MyNotification) {
        notifications.append(notif)
    }
    
    func clearNotifications() {
        self.notifications.removeAll()
    }
    
    func removeNotificaiton(notif: MyNotification) {
        if let index = notifications.firstIndex(where: { $0 == notif }) {
                notifications.remove(at: index)
            }
        }
    
    private func formatNotifsToArr() -> [[String: Any]] {
        var dataArray: [[String: Any]] = []
        
        for notificaiton in self.notifications {
            dataArray.append(notificaiton.modelToData())
        }
        
        return dataArray
    }
    
    func sendNotifcationsToServer() {
        let email = UserService.user.email
        let notificationArray = formatNotifsToArr()
        let db = Firestore.firestore()
        
        db.collection(Collections.Users).document(email).setData(["notifications": notificationArray], merge: true) { (error) in
            if let error = error {
                print("THERE WAS AN ERROR UPDATING NOTIFICATIONS: \(error.localizedDescription) ")
            }
        }
    }
    
    func getNotificationsFromServer() {
        UserService.dispatchGroup.enter()
        clearNotifications()

        let email = UserService.user.email
        print("email", email)
        let db = Firestore.firestore()
        let query = db.collection(Collections.Users).whereField("email", isEqualTo: email)
        
        query.getDocuments(source: .server, completion: { (snapShotArray, err) in
            if let err = err {
                print("could not get notifications \(err.localizedDescription)")
                UserService.dispatchGroup.customLeave()
                return
            }
            
            let snapShot = snapShotArray?.documents[0]

            if let snapShotArray = snapShot?.data()["notifications"] as? [[String: Any]] {
                if snapShotArray.count == 0 { UserService.dispatchGroup.customLeave(); return }
                for notif in snapShotArray {
                    
                    let notificaiton = MyNotification(userInfo: notif)
                    print("NOTIFICATION", notificaiton)
                    NotificationService.addNotificaton(withData: notificaiton)
                    print("NOTIFICATION2", NotificationService.notifications)

                }
                UserService.dispatchGroup.customLeave()

                for notif in NotificationService.notifications {
                    print(notif.date!)
                }
            }
            else {
                UserService.dispatchGroup.customLeave()

            }
        })
    }
}

