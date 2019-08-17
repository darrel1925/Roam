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
    
    func removeLastNotification() {
        self.notifications.removeLast()
    }
    
    func presentAlertIfAny(controllerNamed controller: HomePageViewController) {
        print("notif count is:", notifications.count)
        if notifications.count > 0 {
            if let notif = notifications.last {
                self.handle(notification: notif, controllerNamed: controller)
            }
        }
    }
    
    func handle(notification notif: MyNotification, controllerNamed controller: HomePageViewController) {
        print("notif id is:", notif.notificationId)

    }
    
    func getLastNotificationAlert() -> UIAlertController {
        if notifications.count > 0 {
            if let alert = notifications.last?.createAlert() {
                removeLastNotification()
                return alert
            }
        }
        return UIAlertController()
    }
    
    func presentMapController(controller: HomePageViewController) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapController : MapController = storyboard.instantiateViewController(withIdentifier: "WelcomeID") as! MapController
        let navigationController = UINavigationController(rootViewController: mapController)
        
        controller.present(navigationController, animated: true, completion: nil)
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
        
        db.collection("Users").document(email).setData(["notifications": notificationArray], merge: true) { (error) in
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
        let query = db.collection("Users").whereField("email", isEqualTo: email)
        
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
                    NotificationService.addNotificaton(withData: notificaiton)
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

