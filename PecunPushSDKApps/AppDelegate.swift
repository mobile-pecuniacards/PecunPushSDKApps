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

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, PushAppDelegate {

    public weak var delegate: PushDelegate!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("*:f Push notification received: \(userInfo)")
        
        if let dict = userInfo as NSDictionary? as? [String: Any]? {
            
            guard let body = dict?["body"] as? String else { return }
            guard let optCode = body.getOtp() else { return }
            print("*:* PushCode \(optCode)")
            if delegate != nil {
                delegate.setPushCode(code: optCode, message: body)
            } else {
                let alert = UIAlertController(title: "code".t, message: body, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "btn_accept".t, style: .default, handler: nil))
                let vc = UIApplication.shared.windows.first?.rootViewController
                vc?.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("*:f Firebase registration token: \(fcmToken ?? "-")")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let body = userInfo["body"] as? String {
            
            guard let optCode = body.getOtp() else { return }
            openOtpView(otp: optCode, message: body)
        }
        
        completionHandler()
    }
    
    private func openOtpView(otp: String, message: String) {
        let otpVc = UIAlertController(title: "code".t, message: message, preferredStyle: .alert)
        otpVc.addAction(UIAlertAction(title: "btn_accept".t, style: .default, handler: nil))
        let navController = UINavigationController(rootViewController: otpVc)
        navController.modalPresentationStyle = .fullScreen
        
        // you can assign your vc directly or push it in navigation stack as follows:
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("*e:")
        print("*e 🟥 --- Error Firebase Messaging Register Remote Notifications:")
        print("*e 🟥 \(error.localizedDescription)")
        print("*e:")
    }
}
