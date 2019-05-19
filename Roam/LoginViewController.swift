//
//  LoginViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var skipForNowButton: UIButton!
    
    @IBOutlet weak var signUpEmailButton: UIButton!
    
    @IBOutlet weak var signUpFacebookButton: UIButton!
    
    @IBOutlet weak var getStartedOut: UIButton!
    @IBOutlet weak var loginOut: UIButton!
    //This is a collection of buttons onces the get started button is clicked
    @IBOutlet var signUpCollection: [UIButton]!
    
    //This is what happens when you click on buttuons promoted after the get started button as been clicked EX: signup with facebook
    
    @IBAction func signUpTapped(_ sender: UIButton) {
    }
    
    @IBOutlet weak var LoginImageView: UIImageView!
    
    
    //This button is what happens when you click on Get Started
    @IBAction func onSignUp(_ sender: Any) {
        signUpCollection.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @IBAction func signUpEmailAction(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil )
    }
    @IBAction func OnLogin(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        signUpEmailButton.layer.cornerRadius = 15
        signUpFacebookButton.layer.cornerRadius = 15
        getStartedOut.layer.cornerRadius = 15
        loginOut.layer.cornerRadius = 15
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
