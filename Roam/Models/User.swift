//
//  User.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/27/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseStorage

class User {
    var id: String
    var email:String
    var username: String
    var stripeId: String
    var firstName: String
    var lastName: String
    
    var profilePictureImage: UIImage!
    
    var currentLocationString: String?
    
    var formattedEmail: String {
        return self.email.replacingOccurrences(of: "@", with: "")
    }
    
    init(id: String = "", email: String = "", username: String = "", stripeId: String = "", firstName: String, lastName: String) {
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
        
        self.firstName = firstName
        self.lastName = lastName
        
        
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
        
        self.firstName = "firstName"
        self.lastName = "lastName"
        
        setFCMToken()
        setRoamerFCMToken()
        print("user is made")
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "stripeId" : user.stripeId,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "isCustomer": "true"
        ]
        
        return data
    }
    
    private func setFCMToken() {
        let db = Firestore.firestore()
        
        db.collection(Collections.Users).document(self.email).setData([
            DataParams.FCMToken: UserService.fcmToken,
            ], merge: true
        ) { err in
            if let err = err {
                print("COULD NOT UPDATE FCM TOKEN: \(err.localizedDescription)")
            } else {
                print("Customer fcm Token was updated!")
            }
        }
    }
    
    private func setRoamerFCMToken() {
        let db = Firestore.firestore()
        
        db.collection(Collections.ActiveRoamers).document(self.email).setData([
            DataParams.FCMToken: UserService.fcmToken,
            ], merge: true
        ) { err in
            if let err = err {
                print("COULD NOT UPDATE FCM TOKEN: \(err.localizedDescription)")
            } else {
                print("Roamer fcm Token was updated!")
            }
        }
    }
    
}
