//
//  ChangeRomingStatusController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/25/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChangeRomingStatusController: UIViewController {
    
    @IBOutlet weak var roamingButton: RoundedButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var roamingEnabled: String!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        getRoamingStatus()
        UserService.dispatchGroup.notify(queue: .main, execute: {
            self.roamingButton.isEnabled = true
            self.setInitalButton()

        })
    }
    
    func getRoamingStatus() {
        UserService.dispatchGroup.enter()
        let docRef = db.collection(Collections.ActiveRoamers).document(UserService.user.email)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.roamingEnabled = document[DataParams.roamingEnabled] as? String ?? ""
            } else {
                print("Error roamingEnabled DOES NOT EXIST")
            }
            UserService.dispatchGroup.customLeave()
        }
    }
    
    func setInitalButton() {
        if roamingEnabled == "true"{
            showPauseButton()
        }
        else {
            showEnableButton()
        }
    }
    
    func showEnableButton() {
        self.roamingButton.backgroundColor = #colorLiteral(red: 0.687261939, green: 0.8771608472, blue: 0.6507906318, alpha: 1)
        self.roamingButton.setTitle("Enable Roaming", for: .normal)
        self.titleLabel.text = "Resume Roaming"
        self.descriptionLabel.text = "You will begin to recieve requests To Roam if you 'Resume Roming'."
        roamingEnabled = "false"
    }
    
    func showPauseButton() {
        self.roamingButton.backgroundColor = #colorLiteral(red: 0.6023629904, green: 0.3253927827, blue: 0.3244685531, alpha: 1)
        self.roamingButton.setTitle("Pause Roaming", for: .normal)
        self.titleLabel.text = "Disable Roaming"
        self.descriptionLabel.text = "You will no longer receive requsts to Roam if you 'Pause Roaming'."
        roamingEnabled = "true"
    }
    
    @IBAction func toggleRoaming(_ sender: Any) {
        let docRef = db.collection(Collections.ActiveRoamers).document(UserService.user.email)
        
        if roamingEnabled == "true" {
            
            docRef.setData([DataParams.roamingEnabled: "false"], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                }
                print("Roaming paused")
                self.showEnableButton()
            }
            
        } else {
            
            docRef.setData([DataParams.roamingEnabled: "true"], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                }
                print("Roaming resumed")
                self.showPauseButton()
            }
            
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
