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
    
    var fullTopicEmail: String!
    
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
    
    func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees ){
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func sendLocationToFirebase() {
        
        let db = Firestore.firestore()
        
        // Update one field, creating the document if it does not exist.
        db.collection("ActiveRoamers").document("a@gmail.com").setData([
            "roamerLatitude": latitude,
            "roamerLongitude": longitude
            ], merge: true)
        
    }
    
    func getRoamerEmail() {
        self.dispatchGroup.enter()
        db.collection("ActiveRoamers").whereField("roamerEmail", isEqualTo: "a@gmail.com")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        print("\(document.documentID) => \(document.data())")
                        let email = document.data()["roamerEmail"] as? String
                        self.fullTopicEmail = email
                        print(email ?? "huh", "huhh")
                        self.dispatchGroup.leave()
                    }
                }
        }
        print("email is", self.fullTopicEmail)
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
        
        if user.currentLocationString == nil {
            print("USERS LOCATION COULD NOT BE FOUND")
            return
        }
        
        let formattedEmail = email.replacingOccurrences(of: "@", with: "")

        print("topic email again is: \(formattedEmail) username: \(user.username)")
        
        let data: [String : Any] = [
            "userEmail": user.email,
            "userUserName": user.username,
            "locationName": user.currentLocationString!,
            "notificationId": "RequestToRoam",
            "date": Date().toString()
            ]
        
        let message: [String : Any] = [
            "notification": [
                "title": "New Roam Request!!",
                "body": "CLICK THIS NOTIFICATION to begin!"
            ],
            "data": data,
            "topic": formattedEmail
        ]
        
        // sends notification to roamer's phone
        Functions.functions().httpsCallable("sendNotification").call(message) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                // protocol comes with completion that take in (jsonResponse, error)
                return
            }
            
            
            // adds notification to roamers firebase profile
            self.db.collection("ActiveRoamers").document(email).collection("Notifications").addDocument(data: data, completion: { (error) in
                if let error = error {
                    print("Error writing notification to document: \(error.localizedDescription)")
                } else {
                    print("Document successfully written!")
                }
            })
            
            print(result)
        }
    }
}
