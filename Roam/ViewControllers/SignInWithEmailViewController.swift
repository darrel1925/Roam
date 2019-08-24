//
//  SignInWithEmailViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class SignInWithEmailViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpClicked(_ sender: Any) {
        // TODO: error check inputs
        if !credentialsAreValid() { return }
        
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.displayError(error: error)
                
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let fireUser = result?.user else { return }
            let roamUser = User.init(id: fireUser.uid, email: fireUser.email ?? "error", username: username, stripeId: "")
            
            self.createFireStoreUser(user: roamUser)
            print("registered succesfully")
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: Segues.toHomePage , sender:  nil)
        }
    }
    
    @IBAction func signUpAsRoamer(_ sender: Any) {
    }
    
    func createFireStoreUser(user: User) {

        // Add a new document in collection "Users"
        let db = Firestore.firestore()
        let newUserRef = db.collection(Collections.Users).document(user.email)
        let data = User.modelToData(user: user)
            
        newUserRef.setData(data) { error in
            if let error = error {
                print("Error writing document: \(error)")

            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    
    func credentialsAreValid() -> Bool {
        if !(usernameField.text!.isAlphanumeric && usernameField.text!.count >= 4) {
            let message = "Your username must be at least 4 characters long and contain only alphanumeric characters."
            self.displayError(title: "Whoops.", message: message, completion: {_ in
                // make text field red
            })
            return false
        }
        else if (usernameField.text!.containsWhitespace) {
            let message = "Your username cannot contain any white spaces."
            self.displayError(title: "Whoops.", message: message, completion: {_ in
                // make text field red
            })
            return false
        }
        else if !(passwordField.text!.isAlphanumeric) {
            let message = "Password must be at least 6 charaters and contain no spaces."
            self.displayError(title: "Whoops.", message: message, completion: {_ in
                // make text field red
            })
            return false
        }
        else if !(passwordField.text! == confirmPasswordField.text) {
            let message = "Looks like your passwords don't match. Let's give it another shot."
            self.displayError(title: "Uh Oh.", message: message, completion: {_ in
            })
            return false
        }
        return true
    }
}
