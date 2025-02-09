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
    var roamerNotificationVC: RoamerNotificationController!
    
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
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        print("Accept Clicked")
        // TODO: Check if notification is still active
        
        // get customer's info
        let customersEmail = notification.senderEmail
        let customersFCMToken = notification.senderFCMToken
        
        // send notification back to customer
        UserService.sendNotificationToCustomer(withToken: customersFCMToken, withEmail: customersEmail)
        
        // navigate to map
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoards.Roamer, bundle: nil)
        let roamerMapVC = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.RoamerMapController) as! RoamerMapController
        self.present(roamerMapVC, animated: true, completion: nil)
    }
    
    @IBAction func declineClicked(_ sender: Any) {
        print("Decline Clicked")
        roamerNotificationVC.removeNotification(with: notification)
        dismiss(animated: true, completion: nil)
    }
    
}
