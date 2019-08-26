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
    var user: User! // <- contains stripeId in firebase
    let auth = Auth .auth()
    let db = Firestore.firestore()
    
    var fullTopicEmail: String!
    
    let dispatchGroup = DispatchGroup()
    
    var userListener: ListenerRegistration? = nil // our listener
    var loggedInAsCustomer: Bool!
    var isCustomer: String!
    
    var fcmToken: String = Messaging.messaging().fcmToken!
    var roamersInfoDict: [String: String]! // to send notifications
    
    /********************************************************************/
    /************** Log in/out Functions for User **********************/
    /******************************************************************/
    
    // adds all of our info to our User class to use globally
    func getCurrentUser() {
        // if user is logged in
        guard let authUser = Auth.auth().currentUser else { return }
        
        let userRef = db.collection(Collections.Users).document(authUser.email ?? "no email found")
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
        
        let userRef = db.collection(Collections.Users).document(authUser.email ?? "no email found")
        // if user changes something in document, it will always be up to date in our app
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                UserService.dispatchGroup.customLeave()
                print("could not add snapShotListener :/")
                return
            }
            
            // if we can get user info from db
            guard let data = snap?.data() else {UserService.dispatchGroup.customLeave();  return }
            // add it to out user so we can access it globally
            self.user = User.init(data: data)
            UserService.dispatchGroup.customLeave()
            
        })
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        user = nil
    }
    
    
    /********************************************************************/
    /************** Log in State Tracking Fucntions ********************/
    /******************************************************************/
    
    func switchIsRoaming(to isActive: String){
        let docRef = db.collection(Collections.ActiveRoamers).document(UserService.user.email)
        
        // Set the "capital" field of the city 'DC'
        docRef.updateData([
            "isRoaming": isActive
        ]) { err in
            if let err = err {
                print("Error updating isRoaming: \(err.localizedDescription)")
            } else {
                print("IsActive Updated to \(isActive)")
            }
        }
    }
    
    func switchIsCustomer(to isActive: String){
        let docRef = db.collection(Collections.Users).document(UserService.user.email)
        
        // Set the "capital" field of the city 'DC'
        docRef.updateData([
            "isCustomer": isActive
        ]) { err in
            if let err = err {
                print("Error updating isCustomer: \(err.localizedDescription)")
            } else {
                print("IsCustomer Updated to \(isActive)")
            }
            UserService.dispatchGroup.customLeave()
        }
    }
    
    func getIsCustomer(withEmail email: String) {
        let docRef = db.collection(Collections.Users).document(email)
        self.isCustomer = "true"
        
        docRef.getDocument(source: .server) { (document, error) in
            UserService.dispatchGroup.customLeave()
            
            if let document = document {
                print("Cached document data: \(document.data()?["isCustomer"] ?? "no param isCustomer")")
                self.isCustomer = document.data()?["isCustomer"] as? String ?? "true"
                return
            }
            
            print("Document does not exist in cache")
        }
    }
    
    /********************************************************************/
    /************* Send Notifiactions Helper Functions *****************/
    /******************************************************************/
    
    func getRoamerTokens() {
        dispatchGroup.enter()
        let roamersRef = db.collection(Collections.ActiveRoamers)
        let query = roamersRef.whereField(DataParams.isRoaming, isEqualTo: "true")
        self.roamersInfoDict = [:]
        
        query.getDocuments(source: .server) { (snapShot, error) in
            if let error = error {
                print("COULD NOT GET ROAMERS FROM SERVER: \(error.localizedDescription)")
            }
            
            for document in snapShot!.documents {
                if let email = document.data()[DataParams.roamerEmail] as? String,
                    let token = document.data()[DataParams.FCMToken] as? String {
                    self.roamersInfoDict[email] = token
                }
                
            }
            self.dispatchGroup.customLeave()
            print("roamers Dict is:", self.roamersInfoDict!)
        }
        
        // TODO: Create selection algorithm to choose a series of roamers to ping
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
    
    
    /********************************************************************/
    /************** Send Notifications To Roamer ***********************/
    /******************************************************************/
    func sendNotificationToRoamers() {
        
        if user.currentLocationString == nil {
            print("USERS LOCATION COULD NOT BE FOUND")
            return
        }
        
        let data: [String : Any] = [
            DataParams.senderEmail: user.email,
            DataParams.senderUsername: user.username,
            DataParams.senderFCMToken: fcmToken ,
            DataParams.locationName: user.currentLocationString!,
            DataParams.longitude: "\(LocationService.longitude)",
            DataParams.latitude: "\(LocationService.latitude)",
            DataParams.notificationId: "RequestToRoam",
            DataParams.isActive: "true", // <-- do i need this still
            DataParams.date: Date().toString()
        ]
        
        for (email, token) in self.roamersInfoDict{
            sendToRoamersPhone(withToken: token, withData: data)
            updateRomaersFirbase(withEmail: email, withData: data)
        }
    }
    
    func sendToRoamersPhone(withToken token: String, withData data: [String: Any]) {
        print("send to roamer \(token)")
        let message: [String : Any] = [
            "notification": [
                "title": "New Roam Request!!",
                "body": "CLICK THIS NOTIFICATION to begin!"
            ],
            "data": data,
            "token": token //?? "No Token"
        ]
        //let t = Messaging.messaging().fcmToken
        // sends notification to roamer's phone
        Functions.functions().httpsCallable("sendNotification").call(message) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    
    func updateRomaersFirbase(withEmail email: String, withData data: [String: Any]) {
        let query = self.db.collection(Collections.Users).whereField("email", isEqualTo: email)
        
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
                self.db.collection(Collections.Users).document(email).setData([
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
                // make a new one and send it back
                self.db.collection(Collections.Users).document(email).setData([
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
    
    /********************************************************************/
    /************** Send Notifications To Customer *********************/
    /******************************************************************/
    
    func sendNotificationToCustomer(withToken token: String, withEmail email: String) {
        let data: [String : Any] = [
            DataParams.senderEmail: user.email,
            DataParams.senderUsername: user.username,
            DataParams.senderFCMToken: fcmToken,
            DataParams.longitude: "\(LocationService.longitude)",
            DataParams.latitude: "\(LocationService.latitude)",
            DataParams.notificationId: NotificationIds.AcceptingRequestToRoam,
            DataParams.isActive: "true",
            DataParams.date: Date().toString()
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
        let query = self.db.collection(Collections.Users).whereField("email", isEqualTo: email)
        
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
                self.db.collection(Collections.Users).document(email).setData([
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
                self.db.collection(Collections.Users).document(email).setData([
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

