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
    var localNotifications: [MyNotification]! // to avoid new notifications while tbview is loading
    
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
    
    func removeNotification(with notification: MyNotification) {
        NotificationService.removeNotificaiton(notif: notification)
        NotificationService.sendNotifcationsToServer()
        notificationsCountLabel.text = "\(Int(notificationsCountLabel.text!)! - 1)"
        self.tableView.reloadData()
    }
    
    func requestToRoam(row: Int, notification: MyNotification) {
        let date = notification.date!
        let message = "Looks like this request to roam has expired. Rember to accept them in under 5 minutes."
        
        if (!date.recivedUnderFiveMinutesAgo) {
            // remove notification
            let alert = UIAlertController(title: "Notification Expired", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: {_ in
                self.removeNotification(with: notification)
                return
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        let deliverRequestVC = DeliverRequestController()
        deliverRequestVC.notification = localNotifications[row]
        deliverRequestVC.notificationController = self
        
        
        deliverRequestVC.modalTransitionStyle = .crossDissolve
        deliverRequestVC.modalPresentationStyle = .overCurrentContext
        present(deliverRequestVC, animated: true, completion: nil)
    }
    
    func acceptingRequestToRoam(row: Int, notification: MyNotification) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.MapController) as! MapController
        self.present(mapVC, animated: true, completion: nil)
    }
    
    
    @objc func handleRefresh() {
        // get notifications from server and add to NotificationService
        NotificationService.getNotificationsFromServer()
        
        // get notification count from Notification Service
        UserService.dispatchGroup.notify(queue: .main) {
            self.notificationsCountLabel.text = "\(NotificationService.count)"
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            print(NotificationService.count)
            NotificationService.sendNotifcationsToServer()
        }
        
    }
    
    @IBAction func clearNotificationsClicked(_ sender: Any) {
        let message = "Are you sure you would like to remove all notifications?"
        self.displayError(title: "Clear Notifications", message: message) { _ in
            NotificationService.clearNotifications()
            NotificationService.sendNotifcationsToServer()
            self.setTitle()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension NotificationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localNotifications = NotificationService.notifications
        return localNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let notification = localNotifications[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.RequestToRoamCell) as! RequestToRoamCell
        
        cell.notificationId.text = notification.formatId()
        cell.notificationDate.text = notification.date.toStringInWords()
        cell.notificationDiscription.text = notification.formatMessage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let notification = localNotifications[row]
        
        switch notification.notificationId {
        case NotificationIds.RequestToRoam:
            requestToRoam(row: row, notification: notification)
        case NotificationIds.AcceptingRequestToRoam:
            acceptingRequestToRoam(row: row, notification: notification)
        default:
            self.displayError(title: "Error", message: "Notification Id Not Recognized id = \(notification.notificationId)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = localNotifications[indexPath.row]
            removeNotification(with: notification)
        }
    }
    
}

