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
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        
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
    
    func addRefreshControl() {
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh() {
        // get notifications from server and add to NotificationService
        NotificationService.getNotificationsFromServer()
        
        // get notification count from Notification Service
        UserService.dispatchGroup.notify(queue: .main) {
            self.notificationsCountLabel.text = "\(NotificationService.count)"
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            NotificationService.sendNotifcationsToServer()
        }
        
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
        
        let deliverRequestVC = DeliverRequestController()
        deliverRequestVC.notification = NotificationService.notifications[row]
        deliverRequestVC.notificationController = self
        
        
        deliverRequestVC.modalTransitionStyle = .crossDissolve
        deliverRequestVC.modalPresentationStyle = .overCurrentContext
        present(deliverRequestVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = NotificationService.notifications[indexPath.row]
            NotificationService.removeNotificaiton(notif: notification)
            NotificationService.sendNotifcationsToServer()
            notificationsCountLabel.text = "\(Int(notificationsCountLabel.text!)! - 1)"
            
            self.tableView.reloadData()
        }
    }

}

