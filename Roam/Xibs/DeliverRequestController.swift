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

    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        print("Accept Clicked")
    }
    
    @IBAction func declineClicked(_ sender: Any) {
        print("Decline Clicked")
        dismiss(animated: true, completion: nil)
    }
    
}
