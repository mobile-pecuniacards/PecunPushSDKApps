//
//  AppDelegate.swift
//  PecunPushSDKApps
//
//  Created by Carlos Arismendy on 25/4/22.
//

import UIKit
import PecunPushSDK
import FirebaseMessaging
import FirebaseCore
//import Bagel

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

   var delegate: PushDelegate!

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
      FirebaseApp.configure()

      Messaging.messaging().delegate = self

#if DEBUG
//       Bagel.start()
#endif

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

      application.registerForRemoteNotifications()

      return true
   }

      // MARK: UISceneSession Lifecycle

   @available(iOS 13.0, *)
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         // Called when a new scene session is being created.
         // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   @available(iOS 13.0, *)
   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         // Called when the user discards a scene session.
         // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
         // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }

}

extension AppDelegate: MessagingDelegate {
      // [START refresh_token]
   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(fcmToken ?? "")")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
         name: Notification.Name("FCMToken"),
         object: nil,
         userInfo: dataDict
      )
         // TODO: If necessary send token to application server.
         // Note: This callback is fired at each app startup and whenever a new token is generated.
   }

      // [END refresh_token]
}
