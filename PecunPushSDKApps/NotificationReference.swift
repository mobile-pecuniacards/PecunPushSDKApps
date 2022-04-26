   //
   //  PucunPushExtension.swift
   //  PecunBaseSDKExample
   //
   //  Created by Carlos Arismendy on 12/04/22.
   //

import Foundation
import PecunPushSDK
import UIKit
import FirebaseMessaging

@objcMembers public class NotificationReference: NSObject {

   let messaging: Messaging

   @objc public init( messaging: Messaging) {
      self.messaging = messaging
   }

   @objc public func register(numMp: String, completion: @escaping (Error?) -> Void){
      messaging.token { token, error in
         PecunPush.register(numMp: numMp, token: token, error: error, completion: completion)
      }
   }

}

