//
//  NotificationsController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/14/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var notificationsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setTitle()
    }
    
    func setTitle() {
        if NotificationService.count == 1 {
            notificationsLabel.text = "Notification"
        }
        else {
            notificationsLabel.text = "Notifications"
        }
        notificationsCountLabel.text = String(NotificationService.count)
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension NotificationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let notification = NotificationService.notifications[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestToRoamCell") as! RequestToRoamCell
        
        cell.notificationId.text = notification.formatId()
        cell.notificationDate.text = notification.date.toStringInWords()
        cell.notificationDiscription.text = notification.formatMessage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let DeliverRequestVC = DeliverRequestController()
        
        DeliverRequestVC.modalTransitionStyle = .crossDissolve
        DeliverRequestVC.modalPresentationStyle = .overCurrentContext
        present(DeliverRequestVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = NotificationService.notifications[indexPath.row]
            NotificationService.removeNotificaiton(notif: notification)
            
            self.tableView.reloadData()
        }
    }

}

