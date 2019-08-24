//
//  LoginController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/27/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        let email = emailField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            
            if let error = error {
                self?.displayError(error: error)
                debugPrint(error.localizedDescription)
                self?.activityIndicator.stopAnimating()
                return
            }
            
            print("Login was successful")
            self?.activityIndicator.stopAnimating()
            self?.performSegue(withIdentifier: Segues.toHomePage, sender:  nil)
        }
    }
    @IBAction func logInForRoamer(_ sender: Any) {
    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let forgotPassVC = ForgotPasswordController()
        
        forgotPassVC.modalTransitionStyle = .crossDissolve
        forgotPassVC.modalPresentationStyle = .overCurrentContext
        present(forgotPassVC, animated: true, completion: nil)
    }
    
}
