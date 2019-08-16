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
    
    // TODO: Remove certain notificaiton function
    
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
    
    func updateNotificationsFromServer() {
        let email = UserService.user.email
        print("email", email)
        let db = Firestore.firestore()
        let query = db.collection("Users").whereField("email", isEqualTo: email)
        
        query.getDocuments(source: .server, completion: { (snapShotArray, err) in
            if let err = err {
                print("could not get notifications \(err.localizedDescription)")
            }
            
            let snapShot = snapShotArray?.documents[0]
            if let snapShotArray = snapShot?.data()["notifications"] as? [[String: Any]] {
            
            for notif in snapShotArray {
                
                let notificaiton = MyNotification(userInfo: notif)
                NotificationService.addNotificaton(withData: notificaiton)
            }

            for notif in NotificationService.notifications {
                print(notif.date!)
                UserService.dispatchGroup.customLeave()
                }
            } else {
                print("No Notifications! :p")
            }
        })
    }
}

