    //
    //  ViewController.swift
    //  PecunPushSDKApps
    //
    //  Created by Carlos Arismendy on 25/4/22.
    //

import UIKit
import PecunPushMessagingSDK
import PecunPushSDK
import FirebaseMessaging
import UserNotifications

class SwiftViewController: UITableViewController, UNUserNotificationCenterDelegate, PSD2CallerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mpTf: UITextField!
    @IBOutlet weak var otpTf: UITextField!
    @IBOutlet weak var nifTf: UITextField!
    @IBOutlet weak var uuidTf: UITextField!
    @IBOutlet weak var btnPendingPurchase: UIButton!
    @IBOutlet weak var btnValidateOperation: UIButton!
    @IBOutlet weak var btnCreateDK: UIButton!
    @IBOutlet weak var btnModifyDK: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnUnRegister: UIButton!
    @IBOutlet weak var btnTokenized: UIButton!
    @IBOutlet weak var btnCreateUser: UIButton!
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var btnLinkBiometric: UIButton!
    
        //   public var tokenReference: NotificationReference!

    override func viewDidLoad() {
        super.viewDidLoad()
            //      tokenReference = NotificationReference.init( messaging: Messaging.messaging())
        mpTf.delegate = self
        otpTf.delegate = self
        nifTf.delegate = self
        uuidTf.delegate = self

        let _ = PecunPushMessaging(messaging: Messaging.messaging())
        PecunAppearence.buttonColor = .blue
        PecunAppearence.buttonTextColor = .white
        self.mpTf.text = "A0323JY"
        
        btnPendingPurchase.addTarget(self, action: #selector(pendingPurchace), for: .touchUpInside)
        btnValidateOperation.addTarget(self, action: #selector(validateOperation), for: .touchUpInside)
        btnCreateDK.addTarget(self, action: #selector(createDK), for: .touchUpInside)
        btnModifyDK.addTarget(self, action: #selector(modifyDK), for: .touchUpInside)
        btnPhone.addTarget(self, action: #selector(modifyPhone), for: .touchUpInside)
        btnRegister.addTarget(self, action: #selector(register), for: .touchUpInside)
        btnUnRegister.addTarget(self, action: #selector(unregister), for: .touchUpInside)
        btnTokenized.addTarget(self, action: #selector(tokenized), for: .touchUpInside)
        btnCreateUser.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        btnValidate.addTarget(self, action: #selector(validate), for: .touchUpInside)
        btnLinkBiometric.addTarget(self, action: #selector(linkBiometric), for: .touchUpInside)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.navigationController?.present(alert, animated: false, completion: nil)
    }

    @objc func pendingPurchace() {
        guard let identityDocument = nifTf.text, identityDocument !=  ""  else {
            showAlert(title: "INTRODUZCA NIF", message: "")
            return }
        let viewController  = PecunPush.openPendingPurchase(delegate: self, identityDocument: identityDocument)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func validateOperation() {
        guard let uuidTf = uuidTf.text, uuidTf != "",  let userId = nifTf.text, userId != "" else {
            showAlert(title: "INTRODUZCA UUID y User NIF", message: "")
            return }
            //     let uuid = "1c0f2cfc-648f-41b9-8a7c-d3170b57b4e3"
        let viewController  = PecunPush.openValidateSCAOperation(userId: userId, uuid: uuidTf, delegate: self)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func validate() {
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

    @objc func createDK() {
        guard let numMp = mpTf.text else { return  }
        let viewController  = PecunPush.createSecretCode(numMp: numMp, delegate: self)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func modifyDK() {
        guard let numMp = mpTf.text else { return  }
        let viewController  = PecunPush.modifySecretCode(numMp: numMp, delegate: self)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func modifyPhone() {
        guard let numMp = mpTf.text, let userId = nifTf.text, userId != "" else {
            showAlert(title: "INTRODUZCA MP y User NIF", message: "")
            return  }
        let viewController  = PecunPush.modifyPhone(numMp: numMp, userId: userId, delegate: self)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func register() {
        guard let mp = mpTf.text, !mp.isEmpty else {
            showAlert(title: "INTRODUZCA MP", message: "")
            return
        }

        PecunPushMessaging.register(numMp: mp) { error  in
            if let error = error {
                self.showAlert(title: "RESULT", message: "RESULT -> \(error)")
            } else {
                self.showAlert(title: "RESULT", message: "OK")
            }
        }
    }

    @objc func unregister() {
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

    @objc func tokenized() {
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

    @objc func linkBiometric() {
        guard let nif = nifTf.text, nif != "" else {
            showAlert(title: "INTRODUZCA NIF", message: "")
            return
        }
        let viewController  = PecunPush.openLinkBiometric(delegate: self, userIdentity: nif)
        self.navigationController?.present(viewController, animated: false, completion: nil)
    }

    @objc func createUser() {

    }

    func resendCall() {
        print("resendCall")
    }

    func forgotPassword() {
        print("forgotPassword")
    }

    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        resignFirstResponder()
        return false
    }

}

extension SwiftViewController: PendingPurchaseDelegate, LinkBiometricDelegate {
    func linkBiometricFinishOk() {
        let alert = UIAlertController(title: "", message: "link finish", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    func linkBiometricFinishKo() {
        let alert = UIAlertController(title: "", message: "Finish with error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    func PendingPurchaseFinishOk() {
        let alert = UIAlertController(title: "", message: "Validation finish", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    func PendingPurchaseFinishKo() {
        let alert = UIAlertController(title: "", message: "Finish with error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
