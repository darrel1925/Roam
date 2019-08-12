//
//  AppDelegate.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import Stripe
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        setUpStripe()
        //registerAppForNotifications()
        checkIfUserLoggedIn()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }

    func checkIfUserLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let _ = user {
                self.presentHomePage()
            }
        }
    }
    
    func setUpStripe() {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_QsXnOULAU1t7NqNDJ4ZCWegx00EVMwPd5T"
    }
    
    func presentHomePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomePageVC = storyboard.instantiateViewController(withIdentifier :"HomePage") as! HomePageViewController
        let navController = UINavigationController.init(rootViewController: HomePageVC)
        
        if let window = self.window, let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            currentController.present(navController, animated: true, completion: nil)
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        if ( application.applicationState == .active){
            print("1")
        }
        else if ( application.applicationState == .background){
            print("2")
        }
        // app was already in the foreground
        else if ( application.applicationState == .inactive){
            print("3")
        }
        else {
            print("4")
        }
        // app was just brought from background to foreground
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("11")
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {

            print("Message ID: \(messageID)")
        }
        print("12")
        // Print full message.
        print("fullMessafe", userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

}



@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    // when you recieve notification while in app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        let messageId = userInfo[gcmMessageIDKey] as? String ?? "No message Id"
        
        let message = "Looks like \(userInfo["userUserName"] as? String ?? "Name not found.") would like food delivered to \(userInfo["locationName"] as? String ?? "Location's Name Not Found.") \n Would you like to accept this delivery? "
        let alert = UIAlertController(title: "New Roam Request!", message: message, preferredStyle: .alert)
        
        let notification  = MyNotification(messageId: "messageID", userInfo: userInfo, alert: alert)
        
        NotificationService.addNotificaton(notif: notification)
        
        presentHomePage()


        
        // Print full message.
        print(userInfo)
        print("14")
        // Change this to your preferred presentation option
        completionHandler([.badge, .sound, .alert])
    }
    
    // when i click on notification in app or in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        let messageId = userInfo[gcmMessageIDKey] as? String ?? "No message Id"
        
        let message = "Looks like \(userInfo["userUserName"] as? String ?? "Name not found.") would like food delivered to \(userInfo["locationName"] as? String ?? "Location's Name Not Found.") \n Would you like to accept this delivery? "
        let alert = UIAlertController(title: "New Roam Request!", message: message, preferredStyle: .alert)
        
        let notification  = MyNotification(messageId: messageId, userInfo: userInfo, alert: alert)
        
        NotificationService.addNotificaton(notif: notification)
        
        presentHomePage()

        print("15")
        // Print full message.
        print(userInfo)

        completionHandler()
    }
}

// in order ro register your app to recieve notifications
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("got a message: \(remoteMessage.appData)")
        print("17 ")
    }
}
