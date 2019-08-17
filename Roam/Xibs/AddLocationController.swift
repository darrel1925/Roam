//
//  AddLocationController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/9/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseMessaging

class AddLocationController: UIViewController {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var outterView: UIView!
    
    @IBOutlet weak var placeOrderButton: UIButton!
    
    @IBOutlet weak var additionalInstructionsView: UITextView!
    @IBOutlet weak var buildingNameField: UITextField!
    @IBOutlet weak var roomNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerView.layer.cornerRadius = 20
        placeOrderButton.layer.cornerRadius = 20
        
        additionalInstructionsView.layer.borderColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0).cgColor
        additionalInstructionsView.layer.borderWidth = 2.0
        additionalInstructionsView.layer.cornerRadius = 5
    
        self.outterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.outterView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        //self.outterView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateUserLocationName() {
        let building = buildingNameField.text as? String ?? "No Building Entered"
        let roomNumber = roomNumberField.text as? String ?? "No Building Entered"
        let additionalInfo = additionalInstructionsView.text
        print("current user location = \("Building: \(building ) Room #: \(roomNumber)")" )
        UserService.user.currentLocationString = "Building: \(String(describing: building)) Room # \(roomNumber)"
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 315
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        print("diapatch", UserService.dispatchGroup.count)
        updateUserLocationName()
        LocationService.updateLocation()
        UserService.getRoamerEmail()
        print("topic Name 1: \(String(describing: UserService.fullTopicEmail))")
        UserService.dispatchGroup.notify(queue: .main, execute: {
            print("topic Name 2: \(String(describing: UserService.fullTopicEmail))")
            print("Topic Full email is: \(String(describing: UserService.fullTopicEmail))")
            UserService.sendNotificationToRoamer(withEmail: UserService.fullTopicEmail)
            
            let mapVc = MapController()
            self.present(mapVc, animated: true, completion: nil)
            
        })
    }
}
