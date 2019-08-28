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
    
    func setUpStripe() {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_QsXnOULAU1t7NqNDJ4ZCWegx00EVMwPd5T"
    }
    
    func checkIfUserLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                UserService.dispatchGroup.enter()
                
                UserService.getIsCustomer(withEmail: user.email ?? "no email")
                
                UserService.dispatchGroup.notify(queue: .main, execute: {
                    self.presentHomePage()
                })
            }
        }
    }
    
    func presentHomePage() {
        print("is customer is \(String(describing: UserService.isCustomer)) when presenting homepage")
        if UserService.isCustomer == "true" {
            // show customer home page
            let storyBoard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
            let tabBar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.customerTabBar) as! UITabBarController)
            
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                print("to HomePage")
                currentController.present(tabBar!, animated: true, completion: nil)
                }
        }
        else {
            
            
            
            let storyboard = UIStoryboard(name: StoryBoards.Roamer, bundle: nil)
            let HomePageVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController

            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                print("to mainviewc")
                currentController.present(HomePageVC, animated: true, completion: nil)
            }
            
            
            
//            // show roamer home page
//            let storyBoard = UIStoryboard(name: StoryBoards.Roamer, bundle: nil)
//            let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.roamerTabBar) as! UITabBarController)
//
//            if let window = self.window, let rootViewController = window.rootViewController {
//                var currentController = rootViewController
//                while let presentedController = currentController.presentedViewController {
//                    currentController = presentedController
//                }
//                print("to Romer Home")
//                currentController.present(tabbar!, animated: true, completion: nil)
//            }
        }
    }
    
    func presentNotificationPage() {
        checkIfUserLoggedIn()
//        UserService.dispatchGroup.notify(queue: .main) {
//
//            let storyboard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
//            let NotificationsVC = storyboard.instantiateViewController(withIdentifier: StoryBoardIds.NotificationsController) as! NotificationsController
//            let navController = UINavigationController.init(rootViewController: NotificationsVC)
//
//            if let window = self.window, let rootViewController = window.rootViewController {
//                var currentController = rootViewController
//                while let presentedController = currentController.presentedViewController {
//                    currentController = presentedController
//                }
//                print("to Notifications Controller")
//                currentController.present(navController, animated: true, completion: nil)
//            }
//
//        }
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
        // app was just brought from background to foreground
        else {
            print("4")
        }

        print("Notification Recieved! 5")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        print("Notification Recieved In Background! 6")
        presentNotificationPage()
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    // when you recieve notification while in app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification Recieved While User In App! 7")
        NotificationService.getNotificationsFromServer()
        
        // Change this to your preferred presentation option
        completionHandler([.badge, .sound, .alert])
    }
    
    // when i click on notification in app or in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification Recieved and User Cliked It! 8")
        NotificationService.getNotificationsFromServer()
        presentNotificationPage()
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
        //UserService.fcmToken = fcmToken
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("got a message: \(remoteMessage.appData)")
       print("Notification Recieved  9")
    }

}
