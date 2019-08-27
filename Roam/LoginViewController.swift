//
//  LoginViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var signUpEmailButton: UIButton!
    @IBOutlet weak var signUpFacebookButton: UIButton!
    @IBOutlet weak var getStartedOut: UIButton!
    @IBOutlet weak var loginOut: UIButton!
    
    @IBOutlet var signUpCollection: [UIButton]!
    
    
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        signUpCollection.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }        
    }
    
    @IBAction func signUpEmailAction(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.toSignUpPage, sender: nil )
    }
    
    @IBAction func OnLogin(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.toLoginPage, sender: nil )
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
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
