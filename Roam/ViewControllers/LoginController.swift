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
        guard let email = emailField.text , !email.isEmpty,
              let password = passwordField.text , !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self?.handleError(error: error)
                self?.activityIndicator.stopAnimating()
                return
            }
            
            print("Login was successful")
            self?.activityIndicator.stopAnimating()
            self?.performSegue(withIdentifier: "toHomePage", sender:  nil)
        }
    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // navigationController?.popViewController(animated: true)

    }
    @IBAction func forgotPasswordClicked(_ sender: Any) {
    }
}
