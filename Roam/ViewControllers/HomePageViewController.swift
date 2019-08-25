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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(NotificationService.count)
        print("dispatch begin", UserService.dispatchGroup.count)
        if Auth.auth().currentUser != nil {
            // add all of our info to our User class to use globally
            if UserService.userListener == nil {
                UserService.getCurrentUserForNotifications()
                
            }
        }
        UserService.dispatchGroup.notify(queue: .main) {
            print("dispatch mid", UserService.dispatchGroup.count)
            // get notifications from server and add to NotificationService
            NotificationService.getNotificationsFromServer()
            
            // get notification count from Notification Service
            UserService.dispatchGroup.notify(queue: .main) {
                self.setNotificationBadge()
                print("email2", UserService.user)
                print(NotificationService.count)
                print("diapatch end", UserService.dispatchGroup.count)

            }
        }
    }
    
    func presentLoginController() {
        let storyboard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true, completion: nil)
    }
    
    func setNotificationBadge() {
        print("not", NotificationService.notifications)
        if NotificationService.count == 0 {
            notificationsButton.removeBadge()
            return
        }
        print("notif badge is set t0 \(NotificationService.count)")
        self.notificationsButton?.addBadge(text: String(NotificationService.count))
    }
    
    func logOutUser() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                // removes event listener from fb user reference
                UserService.logoutUser()
                self.presentLoginController()
            } catch {
                let message = "There was an issue logging out. Please try again."
                self.displayError(title: "Whoops.", message: message)
            }
        }
        else {
            self.presentLoginController()
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you would like to log out?", preferredStyle: UIAlertController.Style.alert)
        
        // LOGOUT
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.logOutUser()
        }))
        
        // STAY LOGGED IN
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // present alert
        self.present(alert, animated: true , completion: nil)
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
        let CheckOutVC = storyboard.instantiateViewController(withIdentifier: StoryBoardIds.CheckOutController)
        self.navigationController?.present(CheckOutVC, animated: true, completion: {
            print("CheckOutVC Presented")
        })
    }
    
    @IBAction func mapClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
        let mapController = storyboard.instantiateViewController(withIdentifier: StoryBoardIds.MapController)
        self.navigationController?.present(mapController, animated: true, completion: nil)
    }
    @IBAction func navToRoamerView(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController)
        
        self.present(tabbar!, animated: true, completion: nil)
    }
}
