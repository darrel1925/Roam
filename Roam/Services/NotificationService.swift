//
//  NotificationService.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/11/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import UIKit

let NotificationService = _NotificationService()

class _NotificationService {
    
    var notificationsRecieved: [MyNotification] = []
    var hasNotifsInQueue: Bool { return notificationsRecieved.count > 0}
    
    func addNotificaton(notif: MyNotification) {
        notificationsRecieved.append(notif)
    }
    
    func clearNotifications() {
        self.notificationsRecieved.removeAll()
    }
    
    func removeLastNotification() {
        self.notificationsRecieved.removeLast()
    }
    
    func presentAlertIfAny(controllerNamed controller: HomePageViewController) {
        print("notif count is:", notificationsRecieved.count)
        if notificationsRecieved.count > 0 {
            if let notif = notificationsRecieved.last {
                self.handle(notification: notif, controllerNamed: controller)
            }
        }
    }
    
    func handle(notification notif: MyNotification, controllerNamed controller: HomePageViewController) {
        print("notif id is:", notif.id)
        if notif.id == "RequestToRoam" {
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.presentMapController(controller: controller)
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                print("action cancel handler")
            })
            
            self.removeLastNotification()
            notif.alert.addAction(actionYes)
            notif.alert.addAction(actionCancel)
        }
    }
    
    func getNotificationAlert() -> UIAlertController {
        if notificationsRecieved.count > 0 {
            if let alert = notificationsRecieved.last?.alert {
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
}

