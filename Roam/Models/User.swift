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
    var stripeId: String
    var firstName: String
    var lastName: String
    var fullName: String { return "\(firstName) \(lastName)" }
    var profilePictureImage: UIImage!
    
    var currentLocationString: String?
    
    var formattedEmail: String {
        return self.email.replacingOccurrences(of: "@", with: "")
    }
    
    let db = Firestore.firestore()

    init(id: String = "", email: String = "", firstName: String = "", lastName: String = "", stripeId: String = "") {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.stripeId = stripeId
        
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
        
        
        UserService.isApproved = data["isApproved"] as? Bool ?? false
        
        
        setFCMToken()
        
        if UserService.isCustomer == "false" {
            
            setRoamerFCMToken()
            
        }
        
        print("user is made")
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "stripeId" : user.stripeId,
            "isApproved": UserService.isApproved ?? false, // <-- check that this works in all situations
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
