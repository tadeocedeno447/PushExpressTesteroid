//
//  AppDelegate.swift
//  pushExpressTest
//
//  Created by D K on 01.10.2024.
//

import UIKit
import Firebase
import AppTrackingTransparency
import AdSupport
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import SdkPushExpress

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    private let PUSHEXPRESS_APP_ID = "26604-1202" // set YOUR OWN ID from Push.Express account page
    private var myOwnDatabaseExternalId = ""      // you can just leave it empty in most cases

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //fire
        FirebaseApp.configure()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print("Permission granted: \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        //express
        try! PushExpressManager.shared.initialize(appId: PUSHEXPRESS_APP_ID)
        
        try! PushExpressManager.shared.activate(extId: myOwnDatabaseExternalId)
        print("externalId: '\(PushExpressManager.shared.externalId)'")
        
        if !PushExpressManager.shared.notificationsPermissionGranted {
            // show your custom message like "Go to iOS Settings and enable notifications"
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //Messaging
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //fire
        Messaging.messaging().apnsToken = deviceToken
        
        //express
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        PushExpressManager.shared.transportToken = tokenParts.joined()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotifiaction"), object: nil, userInfo: userInfo)
        completionHandler()
    }

}

