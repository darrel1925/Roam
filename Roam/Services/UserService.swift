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
    
    var fullTopicEmail: String!
    
    let dispatchGroup = DispatchGroup()
    // our listener
    var userListener: ListenerRegistration? = nil
    
    var fcmToken: String!
    
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
            guard let data = snap?.data() else {  return }
            // add it to out user so we can access it globally
            self.user = User.init(data: data)
            
        })
        
    }
    
    func getCurrentUserForNotifications() {
        // if user is logged in
        UserService.dispatchGroup.enter()
        guard let authUser = Auth.auth().currentUser else {  UserService.dispatchGroup.customLeave(); return }
        
        let userRef = db.collection("Users").document(authUser.email ?? "no email found")
        // if user changes something in document, it will always be up to date in our app
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                UserService.dispatchGroup.customLeave()
                print("could not add snapShotListener :/")
                return
            }
            
            // if we can get user infor from db
            guard let data = snap?.data() else {UserService.dispatchGroup.customLeave();  return }
            // add it to out user so we can access it globally
            self.user = User.init(data: data)
            UserService.dispatchGroup.customLeave()
            
        })
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        user = User()
    }
    
    func getRoamerEmail() {
        // TODO: Create selection algorithm to choose a series of roamers to ping
        self.dispatchGroup.enter()
        db.collection("ActiveRoamers").whereField("roamerEmail", isEqualTo: "a@gmail.com").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                    self.dispatchGroup.customLeave()

                }
                else {
                    for document in querySnapshot!.documents {
                        
                        print("\(document.documentID) => \(document.data())")
                        let email = document.data()["roamerEmail"] as? String
                        self.fullTopicEmail = email
                        print(email ?? "huh", "huhh")
                    }
                    self.dispatchGroup.customLeave()
                }
        }
        print("email is", self.fullTopicEmail)
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
        
        let data: [String : Any] = [
            "senderEmail": user.email,
            "senderUsername": user.username,
            "senderFCMToken": fcmToken ?? "No Token",
            "locationName": user.currentLocationString!,
            "longitude": "\(LocationService.longitude)",
            "latitude": "\(LocationService.latitude)",
            "notificationId": "RequestToRoam",
            "isActive": "true",
            "date": Date().toString()
            ]
        
        
        sendToRoamersPhone(withEmail: email, withData: data)
        updateRomaersFirbase(withEmail: email, withData: data)
    }
    
    func sendToRoamersPhone(withEmail email: String, withData data: [String: Any]) {
        let formattedEmail = email.replacingOccurrences(of: "@", with: "")

        let message: [String : Any] = [
            "notification": [
                "title": "New Roam Request!!",
                "body": "CLICK THIS NOTIFICATION to begin!"
            ],
            "data": data,
            "topic": "agmail.com" //?? "No Token"
        ]
        
        // sends notification to roamer's phone
        Functions.functions().httpsCallable("sendNotification").call(message) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    
    func updateRomaersFirbase(withEmail email: String, withData data: [String: Any]) {
        let query = self.db.collection("Users").whereField("email", isEqualTo: email)
        
        query.getDocuments(source: .server, completion: { (snapShot, error) in
            if let error = error {
                print("could not update notifications \(error.localizedDescription)")
            }
            
            // a notification array has been made
            if let notifArr = snapShot?.documents[0].data()["notifications"] {
                // update it
                var notifArr = notifArr as! [Any]
                notifArr.append(data)
                // send it back
                self.db.collection("Users").document(email).setData([
                    "notifications": notifArr], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!!!!")
                        }
                }
            }
            // a notification array has NOT been made
            else {
                print("not been made")
                // make a new one
                // send it back
                self.db.collection("Users").document(email).setData([
                    "notifications": [data]], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!!!!")
                        }
                }
                
            }
        })
    }
    
    
    /******************************************************************/
    
    func sendNotificationToCustomer(withToken token: String, withEmail email: String) {
        let data: [String : Any] = [
            "senderEmail": user.email,
            "senderUsername": user.username,
            "senderFCMToken": fcmToken ?? "No Token",
            "longitude": "\(LocationService.longitude)",
            "latitude": "\(LocationService.latitude)",
            "notificationId": "AcceptingRequestToRoam",
            "isActive": "true",
            "date": Date().toString()
        ]
        
        self.sendToCustomersPhone(withToken: token, withData: data)
        self.updateCustomersFirbase(withEmail: email, withData: data)
    }
    
    func sendToCustomersPhone(withToken token: String, withData data: [String: Any]) {
        
        let message: [String : Any] = [
            "notification": [
                "title": "New Roam Request!!",
                "body": "CLICK THIS NOTIFICATION to begin!"
            ],
            "data": data,
            "token": token
        ]
        
        // sends notification to roamer's phone
        Functions.functions().httpsCallable("sendNotification").call(message) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    
    func updateCustomersFirbase(withEmail email: String, withData data: [String: Any]) {
        let query = self.db.collection("Users").whereField("email", isEqualTo: email)
        
        query.getDocuments(source: .server, completion: { (snapShot, error) in
            if let error = error {
                print("could not update notifications \(error.localizedDescription)")
            }
            
            // a notification array has been made
            if let notifArr = snapShot?.documents[0].data()["notifications"] {
                // update it
                var notifArr = notifArr as! [Any]
                notifArr.append(data)
                // send it back
                self.db.collection("Users").document(email).setData([
                    "notifications": notifArr], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!!!!")
                        }
                }
            }
                // a notification array has NOT been made
            else {
                print("not been made")
                // make a new one
                // send it back
                self.db.collection("Users").document(email).setData([
                    "notifications": [data]], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!!!!")
                        }
                }
                
            }
        })
    }
}

