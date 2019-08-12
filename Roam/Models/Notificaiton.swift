//
//  Notificaiton.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/11/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import UIKit

struct MyNotification {
    
    var messageId: String
    var userInfo: [AnyHashable : Any]
    var alert: UIAlertController
    var id: String { return self.userInfo["notificationId"] as! String}

    
    init(messageId: String, userInfo: [AnyHashable : Any], alert: UIAlertController) {
        self.messageId = messageId
        self.userInfo = userInfo
        self.alert = alert
    }
}
