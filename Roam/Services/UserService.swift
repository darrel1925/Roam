//
//  UserService.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/24/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//


// fetch and listen to changes to our user document
import UIKit
import FirebaseAuth
import FirebaseFirestore

// so we can refer to this singlton with just 'UserService' in our code
let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User() // <- contains stripeId in firebase 
    let auth = Auth .auth()
    let db = Firestore.firestore()
    
    // our listener
    var userListener: ListenerRegistration? = nil
    
    // adds all of our info to our User class to use globally
    func getCurrentUser() {
        // if user is logged in
        guard let authUser = Auth.auth().currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        // if user changes something in document, it will always be up to date in our app
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                print("could not add snapShotListener :/")
                return
            }
            
            // if we can get user info from db
            guard let data = snap?.data() else { return }
            // add it to out user so we can access it globally
            self.user = User.init(data: data)
        })        
    }
    
    func anything() {
        
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        user = User()
    }
    
    func sendLocationToFirebase() {
        let db = Firestore.firestore()
        // Update one field, creating the document if it does not exist.
        db.collection("users").document(self.user.id).setData([ "capital": true ], merge: true)
    }
}
