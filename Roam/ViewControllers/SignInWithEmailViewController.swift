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

//Chinenye - made this to change the padding of a text field to only one border under it
extension UITextField{
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0
            , y: 0
            , width: 10, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    
    func setBottomBorder(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0,height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}

class SignInWithEmailViewController: UIViewController {

    func setTextLine(){
        fullNameField.setBottomBorder()
        fullNameField.setPadding()
        emailField.setBottomBorder()
        emailField.setPadding()

        passwordField.setBottomBorder()
        passwordField.setPadding()
      confirmPasswordField.setBottomBorder()
        confirmPasswordField.setPadding()
        
    }
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextLine()

    }
    
    func addRoamerToActiveRoamers(email: String) {
        let db = Firestore.firestore()
        db.collection(Collections.ActiveRoamers).document(email).setData([
            DataParams.customerLatitude: 0,
            DataParams.customerLongitude: 0,
            DataParams.isActive: "true",
            DataParams.roamerEmail: email,
            DataParams.roamerLatitude: 0,
            DataParams.roamerLongitude: 0,
            DataParams.roamingEnabled: "true"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                self.displayError(error: err)
            } else {
                print("Document successfully written!")
            }
        }
    }

    func createFireStoreUser(user: User) {

        // Add a new document in collection "Users"
        let db = Firestore.firestore()
        let newUserRef = db.collection(Collections.Users).document(user.email)
        var data = User.modelToData(user: user)
        
        if !UserService.loggedInAsCustomer {
            data["isCustomer"] = "false"
        }
        else {
            data["isCustomer"] = "true"
        }
        
        newUserRef.setData(data) { error in
            if let error = error {
                print("Error writing document: \(error)")

            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func credentialsAreValid() -> Bool {
        
        if !(self.fullNameField.text!.isValidName) {
            let message = "Please enter valid first and last name. (Ex. Michael Young)"
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
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        // TODO: error check inputs
        if !credentialsAreValid() { return }
        
        UserService.loggedInAsCustomer = true
        
        let fullName = fullNameField.text!.separateName()
        let email = emailField.text!
        let password = passwordField.text!
        let firstName = fullName[0]
        let lastName = fullName[1]
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.displayError(error: error)
                
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let fireUser = result?.user else { return }
            let customer = User.init(id: fireUser.uid,
                                     email: fireUser.email ?? "error",
                                     firstName: firstName,
                                     lastName: lastName,
                                     stripeId: "")
            
            self.createFireStoreUser(user: customer)
            print("registered succesfully")
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func signUpForRoamer(_ sender: Any) {
        
        if !credentialsAreValid() { return }
        
        UserService.loggedInAsCustomer = false
        
        let fullName = fullNameField.text!.separateName()
        let email = emailField.text!
        let password = passwordField.text!
        let firstName = fullName[0]
        let lastName = fullName[1]
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.displayError(error: error)
                
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let fireUser = result?.user else { return }
            let roamer = User.init(id: fireUser.uid,
                                     email: fireUser.email ?? "error",
                                     firstName: firstName,
                                     lastName: lastName,
                                     stripeId: ""
            )
            print("registered succesfully")
            
            self.createFireStoreUser(user: roamer)
            self.addRoamerToActiveRoamers(email: email)
            self.activityIndicator.stopAnimating()
            

        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
