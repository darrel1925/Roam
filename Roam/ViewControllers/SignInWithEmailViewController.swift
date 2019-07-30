//
//  SignInWithEmailViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Firebase


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
        let username = usernameField.text ?? "fakeUsername"
        guard let email = emailField.text , !email.isEmpty else { return }
        let password = passwordField.text ?? "fakePassword"
        activityIndicator.startAnimating()
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                debugPrint(error)
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let fireUser = result?.user else { return }
            let roamUser = User.init(id: fireUser.uid, email: fireUser.email ?? "error", username: username, stripeId: "")
            
            self.createFireStoreUser(user: roamUser)
            print("registered succesfully")
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toHomePage", sender:  nil)
        }
    }
    
    func createFireStoreUser(user   : User) {
        // Add a new document in collection "Users"
        let db = Firestore.firestore()
        

        let newUserRef = db.collection("users").document(user.id)
            
        let data = User.modelToData(user: user)
            
        newUserRef.setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
}
