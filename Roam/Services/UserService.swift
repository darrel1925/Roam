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
import FirebaseMessaging
import FirebaseFunctions
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
    
    var topicToJoin: String!
    
    let dispatchGroup = DispatchGroup()
    // our listener
    var userListener: ListenerRegistration? = nil
    
    // adds all of our info to our User class to use globally
    func getCurrentUser() {
        // if user is logged in
        guard let authUser = Auth.auth().currentUser else { return }
        
        let userRef = db.collection("Users").document(authUser.email ?? "no email found")
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
    
    func getLocation(mapController: Any) ->  CLLocationManager{
        let locationManager = CLLocationManager() // Manages Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // only request to use when the app is running
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.latitude = (locationManager.location?.coordinate.latitude)!
        self.longitude = (locationManager.location?.coordinate.longitude)!
        
        return locationManager
    }
    
    func sendLocationToFirebase() {
        
        let db = Firestore.firestore()
        
        // Update one field, creating the document if it does not exist.
        //db.collection("user").document(user.email).setData([ "locationName": "hello werld" ], merge: true)
        
        let docData: [String: Any] = [
            "latitude": self.longitude,
            "longitude": self.latitude
        ]
        
        
        db.collection("Users").document(user.email).setData(docData, merge: true) { err in
            if let err = err {
                UIViewController().displayError(error: err)
            } else {
                
                UIViewController().displayError(title: "great", message: "cool")
                print("Document successfully written!")
            }
        }
        
        Messaging.messaging().unsubscribe(fromTopic: "weather") { error in
            if let error = error {
                print(error)
            }
            print("Unsubscribed to weather topic")
        }
    }
    
    func getRoamerEmail() {
        self.dispatchGroup.enter()
        db.collection("ActiveRoaming").whereField("email", isEqualTo: "a@gmail.com")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        print("\(document.documentID) => \(document.data())")
                        let email = document.data()["email"] as? String
                        self.topicToJoin = email
                        print(email ?? "huh", "huhh")
                        self.dispatchGroup.leave()
                    }
                }
        }
        print("email is", self.topicToJoin)
    }
    
    func sendMessage(toTopic topic: String) {
        
    }
    
    func subScribeToTopic(email: String) {
        let email = email.replacingOccurrences(of: "@", with: "")
        
        Messaging.messaging().subscribe(toTopic: email) { error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            print("Subscribed to \(self.user.email) topic")
        }
    }
    
    func sendNotificationToRoamer(withEmail email: String) {
        
        print("topic email again is: \(email) username: \(user.username)")
        let message: [String : Any] = [
            "notification": [
                "title": "New Roam Request!!",
                "body": "CLICK THIS NOTIFICATION to begin!"
            ],
            "data": [
                "userEmail": user.email,
                "userUserName": user.username,
                "locationName": user.currentLocationString,
                "notificationId": "RequestToRoam"
            ],
            "topic": email
        ]
        
        Functions.functions().httpsCallable("sendNotification").call(message) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                // protocol comes with completion that take in (jsonResponse, error)
                return
            }
            
            print(result)
        }
    }
}
