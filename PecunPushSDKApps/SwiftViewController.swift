//
//  ViewController.swift
//  PecunPushSDKApps
//
//  Created by Carlos Arismendy on 25/4/22.
//

import UIKit
import PecunPushSDK
import PecunPushMessagingSDK
import FirebaseMessaging
import UserNotifications

class SwiftViewController: UITableViewController, UNUserNotificationCenterDelegate, PSD2CallerDelegate {


   @IBOutlet weak var mpTf: UITextField!
   @IBOutlet weak var otpTf: UITextField!
   @IBOutlet weak var nifTf: UITextField!
   @IBOutlet weak var uuidTf: UITextField!
   @IBOutlet weak var nifBiometricTf: UITextField!


   override func viewDidLoad() {
      super.viewDidLoad()
      let _ = PecunPushMessaging(messaging: Messaging.messaging())
      PecunAppearence.buttonColor = .blue
      self.mpTf.text = "A0323JY"
   }

   @IBAction func isDeviceTokenizedAction(_ sender: Any) {
      guard let identityDocument = mpTf.text else {
         showAlert(title: "INTRODUZCA MP", message: "")
         return
      }

      if PecunPush.isDeviceTokenized(identityDocument: identityDocument) {
         self.showAlert(title: "RESULT", message: "Device already tokenized")
      } else {

         self.showAlert(title: "RESULT", message: "Device NOT tokenized")
      }

   }

   @IBAction func registerAction(_ sender: Any) {

      guard let mp = mpTf.text else {
         showAlert(title: "INTRODUZCA MP", message: "")
         return
      }

      PecunPushMessaging.register(numMp: mp, completion: { error  in
         if let error = error {
            self.showAlert(title: "RESULT", message: "RESULT -> \(error)")
         } else {
            self.showAlert(title: "RESULT", message: "OK")
         }
      })

   }

   @IBAction func unregisterAction(_ sender: Any) {

      guard let mp = mpTf.text else {
         showAlert(title: "INTRODUZCA MP", message: "")
         return
      }

      PecunPush.unregister(numMp: mp, completion: { error in
         if let error = error {
            self.showAlert(title: "RESULT", message: "RESULT -> \(error)")
         } else {
            self.showAlert(title: "RESULT", message: "OK")
         }

      })
   }

   @IBAction func validateAction(_ sender: Any) {

      guard let otp = otpTf.text else {
         showAlert(title: "INTRODUZCA OTP", message: "")
         return
      }
      PecunPush.validate(otp: otp, completion: { error  in
         if let error = error {
            self.showAlert(title: "RESULT", message: "RESULT -> \(error)")
         } else {
            self.showAlert(title: "RESULT", message: "OK")
         }
      })
   }

   @IBAction func linkBiometricAction(_ sender: Any) {

      guard let nif = nifBiometricTf.text, nif != "" else {
         showAlert(title: "INTRODUZCA NIF", message: "")
         return
      }
      let viewController  = PecunPush.openLinkBiometric(delegate: self, userIdentity: nif)
      self.navigationController?.present(viewController, animated: false, completion: nil)

   }

   @IBAction func openViewAction(_ sender: Any) {

      guard let identityDocument = nifTf.text, identityDocument !=  ""  else {
         showAlert(title: "INTRODUZCA NIF", message: "")
         return }
      let viewController  = PecunPush.openPendingPurchase(delegate: self, identityDocument: identityDocument)
      self.navigationController?.present(viewController, animated: false, completion: nil)
   }

   @IBAction func openCreateSecretCode(_ sender: Any) {
         //        let viewController  = pecunPushLibrary.openBiometricAuth(delegate: self)
         //        self.present(viewController, animated: false, completion: nil)
   }

   @IBAction func validateOperation(_ sender: Any) {
      guard let uuidTf = uuidTf.text else { return }
         //     let uuid = "1c0f2cfc-648f-41b9-8a7c-d3170b57b4e3"
      let viewController  = PecunPush.openValidateSCAOperation(uuid: uuidTf, delegate: self)
         //       let viewController = PecunAlertViewController.createAlertViewController(title: "Titulo", message: "Prueba", koButtonText: "No", okButtonText: "ok")
      self.navigationController?.present(viewController, animated: false, completion: nil)

   }

   private func showAlert(title: String, message: String) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.navigationController?.present(alert, animated: false, completion: nil)
   }

   func resendCall() {
      print("resendCall")
   }

   func forgotPassword() {
      print("forgotPassword")
   }

}

extension SwiftViewController: PendingPurchaseDelegate, LinkBiometricDelegate {
   func linkBiometricFinishOk() {
      let alert = UIAlertController(title: "", message: "link finish", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.navigationController?.present(alert, animated: true, completion: nil)
   }

   func linkBiometricFinishKo() {
      let alert = UIAlertController(title: "", message: "Finish with error", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.navigationController?.present(alert, animated: true, completion: nil)
   }

   func PendingPurchaseFinishOk() {
      let alert = UIAlertController(title: "", message: "Validation finish", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.navigationController?.present(alert, animated: true, completion: nil)
   }

   func PendingPurchaseFinishKo() {
      let alert = UIAlertController(title: "", message: "Finish with error", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.navigationController?.present(alert, animated: true, completion: nil)
   }
}

extension UIViewController {
   func embed(_ viewController:UIViewController, inView view:UIView){
      viewController.willMove(toParent: self)
      viewController.view.frame = view.bounds
      view.addSubview(viewController.view)
      self.addChild(viewController)
      viewController.didMove(toParent: self)
   }
}

func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
   viewController.willMove(toParent: controller)
   viewController.view.frame = view.bounds
   view.addSubview(viewController.view)
   controller.addChild(viewController)
   viewController.didMove(toParent: controller)
}

extension SwiftViewController {
      // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
      return 1
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of rows
      return 1
   }
}
