//
//  DeliverRequestController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/15/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class DeliverRequestController: UIViewController {

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var conatinerView: UIView!
    
    var notification: MyNotification!
    var notificationController: NotificationsController!
    var senderEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptButton.layer.cornerRadius = 15
        declineButton.layer.cornerRadius = 15
        backgroundView.layer.cornerRadius = 20
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        showPopUp()
        
    }
    
    func showPopUp() {
        // TODO: add animation to pop up from bottom of screen
    }
    
    func createNotification() -> [String: Any] {
        return [
            "senderEmail": UserService.user.email,
            "senderUsername": UserService.user.username,
            "locationName": UserService.user.currentLocationString!,
            "longitude": "\(LocationService.longitude)",
            "latitude": "\(LocationService.latitude)",
            "notificationId": "AcceptingRequestToRoam",
            "isActive": "true",
            "date": Date().toString()
        ]
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        print("Accept Clicked")
        // TODO: Check if notification is still active
        
        // send notification back to customer
        let data = createNotification()
        UserService.sendToCustomersPhone(withEmail: UserService.user.email, withData: data)
        
        // get senders email
        senderEmail = notification.senderEmail
        
        // navigate to map
        let roamerMapVC = RoamerMapController()
        present(roamerMapVC, animated: true, completion: nil)
    }
    
    @IBAction func declineClicked(_ sender: Any) {
        print("Decline Clicked")
        NotificationService.removeNotificaiton(notif: notification)
        NotificationService.sendNotifcationsToServer()
        
        notificationController.notificationsCountLabel.text = "\(NotificationService.count)"
        notificationController.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}
