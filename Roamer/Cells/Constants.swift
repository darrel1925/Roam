//
//  Constants.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/17/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation

struct StoryBoards {
    static let Main = "Main"
    static let Roamer = "Roamer"
}

struct DataParams {
    // creating payments
    static let total = "total"
    static let customer_id = "customer_id"
    static let idempotency = "idempotency"
    
    static let customerLatitude = "customerLatitude"
    static let customerLongitude = "customerLongitude"
    static let roamerLatitude = "roamerLatitude"
    static let roamerLongitude = "roamerLongitude"
    
    static let roamerEmail = "roamerEmail"
    static let senderEmail = "senderEmail"
    static let senderFirstName = "senderFirstName"
    static let senderLastName = "senderLastName"
    static let senderFCMToken = "senderFCMToken"
    static let locationName = "locationName"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let notificationId = "notificationId"
    static let isActive = "isActive"
    static let isRoaming = "isRoaming"
    static let isCustomer = "isCustomer"
    static let date = "date"
    
    static let roamingEnabled = "roamingEnabled"
    static let FCMToken = "FCMToken"
}

struct NotificationIds {
    static let RequestToRoam = "RequestToRoam"
    static let AcceptingRequestToRoam = "AcceptingRequestToRoam"
}

struct StoryBoardIds {
    // Storyboard Ids
    static let CheckOutController = "CheckOutController"
    static let MapController = "MapController"
    static let RoamerMapController = "RoamerMapController"
    static let NotificationsController = "NotificationsController"
    static let HomePageViewController = "HomePageController"
    static let ProfileController = "ProfileController"
    static let EarningsController = "EarningsController"
    static let LoginController = "LoginController"
    static let SignInWithEmailViewController = "SignInWithEmailViewController"
    
    static let customerTabBar = "customerTabBar"
    static let roamerTabBar = "roamerTabBar"
    static let tabBar = "tabBar"

}

struct Segues {
    static let toHomePage = "toHomePage"
    static let toMapController = "toMapController"
    static let ItemDescriptionCell = "ItemDescriptionCell"
    static let toLoginPage = "toLoginPage"
    static let toSignUpPage = "toSignUpPage"
}

struct Collections {
    static let Users = "Users"
    static let ActiveRoamers = "ActiveRoamers"
}

struct Cells {
    static let ShoppingCartCell = "ShoppingCartCell"
    static let RequestToRoamCell = "RequestToRoamCell"
    static let TitleCell = "TitleCell"
    static let ItemDescriptionCell = "ItemDescriptionCell"
    
    static let EntreeTitleCell = "EntreeTitleCell"
    static let ChooseEntreeCell = "ChooseEntreeCell"
    
    static let ProfileSectionCell = "ProfileSectionCell"
    static let ProfileInfoCell = "ProfileInfoCell"
}

struct Images {
    static let check = "check"
}

