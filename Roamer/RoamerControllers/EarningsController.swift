//
//  EarningsController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/1/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseAuth

class EarningsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
                UserService.switchIsActive(to: "true")
                print(NotificationService.count)
                print("diapatch end", UserService.dispatchGroup.count)
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsCell") as! EarningsCell
            cell.titleLabel.text = "Current Week"
            cell.moneyEarnedLabel.text = "$26.35"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsTitleCell") as! EarningsTitleCell
            cell.dateLabel.text = "August 2019"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarningsDetailCell") as! EarningsDetailCell
            cell.datesLabel.text = "April 23 - April 30"
            cell.moneyEarnedLabel.text = "$128.44"
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "error"
        }
        return UITableViewCell()
    }
    
}


extension EarningsController: UITabBarControllerDelegate {
    

    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller: \(tabBarController.selectedIndex)")
    }
}
