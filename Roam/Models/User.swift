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


struct User {
    var id: String
    var email:String
    var username: String
    var stripeId: String
    var firstName: String
    var lastName: String

    var currentLocationString: String?
    
    var formattedEmail: String {
        return self.email.replacingOccurrences(of: "@", with: "")
    }
    
    init(id: String = "", email: String = "", username: String = "", stripeId: String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
        
        self.firstName = "firstName"
        self.lastName = "lastName"

    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
        
        self.firstName = "firstName"
        self.lastName = "lastName"
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "stripeId" : user.stripeId
        ]
        
        return data
    }

    
}
