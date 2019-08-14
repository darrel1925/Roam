//
//  HomePageViewController.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {

    @IBOutlet weak var notificationsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(NotificationService.count)
        UserService.dispatchGroup.enter()
        print("dispatch", UserService.dispatchGroup.count)
        if Auth.auth().currentUser != nil {
            // add all of our info to our User class to use globally
            if UserService.userListener == nil {
                UserService.getCurrentUserForNotifications()
                
            }
            else {
                UserService.dispatchGroup.customLeave()
            }
        }
        else {
            UserService.dispatchGroup.customLeave()
        }
        
        UserService.dispatchGroup.notify(queue: .main) {
            UserService.dispatchGroup.enter()
            // get notifications from server and add to NotificationService
            NotificationService.clearNotifications()
            NotificationService.updateNotificationsFromServer()
            
            // get notification count from Notification Service
            UserService.dispatchGroup.notify(queue: .main) {
                self.setNotificationBadge()
                print("email2", UserService.user)
                print(NotificationService.count)
            }

        }
    }
    
    func presentLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true, completion: nil)
    }
    
    func setNotificationBadge() {
        if NotificationService.count == 0 {
            notificationsButton.removeBadge()
            return
        }
        self.notificationsButton?.addBadge(text: String(NotificationService.count))
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                // removes event listener from fb user reference
                UserService.logoutUser()
                presentLoginController()
            } catch {
                // TOTO: show error message
                print("could not log out")
            }
        }
        else {
            presentLoginController()
        }
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CheckOutVC = storyboard.instantiateViewController(withIdentifier: "CheckOutController")
        self.navigationController?.present(CheckOutVC, animated: true, completion: {
            print("CheckOutVC Presented")
        })
    }
    
    @IBAction func mapClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapController = storyboard.instantiateViewController(withIdentifier: "MapController")
        self.navigationController?.present(mapController, animated: true, completion: nil)
    }
}
