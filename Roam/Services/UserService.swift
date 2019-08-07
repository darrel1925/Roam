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
import CoreLocation

// so we can refer to this singlton with just 'UserService' in our code
let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User() // <- contains stripeId in firebase 
    let auth = Auth .auth()
    let db = Firestore.firestore()
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
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
            
            // if we can get user infor from db
            guard let data = snap?.data() else { return }
            // add it to out user so we can access it globally
            self.user = User.init(data: data)
        })        
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        user = User()
    }
    
    func getLocation() {
        let locationManager = CLLocationManager() // Manages Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // only request to use when the app is running
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        self.latitude = (locationManager.location?.coordinate.latitude)!
        self.longitude = (locationManager.location?.coordinate.longitude)!
    }
    
    
}
