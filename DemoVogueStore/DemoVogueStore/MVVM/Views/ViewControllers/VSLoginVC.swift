//
//  VSLoginVC.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import UIKit
import LocalAuthentication
import NVActivityIndicatorView
import AudioToolbox

class VSLoginVC: UIViewController {
    
    var arrayModelVogueDashboard: [VSViewModelVogue] = []
    var arrayModelVogueShop: [VSViewModelVogue] = []
    var modelVogueFeatured: VSViewModelVogue?
    
    @IBOutlet weak var viewTouch: UIView!
    
    // MARK:-- View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: internetReachability)
        do{
            try internetReachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        hideViewTouchID(true)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        internetReachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: internetReachability)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segID_VSDashboardVC" {
            let vc = segue.destination as! VSDashboardVC
            vc.arrayModelVogueDashboard = arrayModelVogueDashboard
            vc.arrayModelVogueShop = arrayModelVogueShop
            vc.modelVogueFeatured = modelVogueFeatured
        }
    }
    
    // MARK:-- Custom Methods
    
    func checkInternet() {
        
        //Playing vibration when authenfication successfull
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
        //Displaying Activity Indicator
        showIndicator()
        
        //Checking internet connectivity
        switch internetReachability.connection {
        case .wifi:
            callAPI()
        case .cellular:
            callAPI()
        case .none:
            noInternet()
        }
    }
    
    // Creating request
    func callAPI() {
        self.arrayModelVogueDashboard = []
        self.arrayModelVogueShop = []
        
        VSManagerVogueList.sharedInstance.delegateManager = self
        VSManagerVogueList.sharedInstance.createRequest()
    }
    
    // No internet sub-method
    func noInternet() {
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
        hideViewTouchID(true)
        self.hideIndicator()
        self.popupAlert(title: "Info", message: "Please check your internet connection.", actionTitles: ["Ok"], actions:[{action1 in
            }, nil])
    }
    
    // Hiding touch view
    func hideViewTouchID(_ isHide: Bool) {
        DispatchQueue.main.async {
            self.viewTouch.isHidden = isHide
        }
    }
    
    // Reachibility observer
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            noInternet()
            print("Network not reachable")
        }
    }
    
    // MARK:-- Outlets
    
    @IBAction func actBtnLogin(_ sender: Any) {
        
        hideViewTouchID(false)
        authenticationWithTouchID()
    }
}

extension VSLoginVC {
    
    // MARK:-- Touch ID Methods
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Go Back"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    self.checkInternet()
                    
                } else {
                    
                    self.hideViewTouchID(true)
                    
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            hideViewTouchID(true)
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

extension VSLoginVC: VSManagerVogueListProtocol {
    
    // MARK:-- Network Protocol Delegation
    
    func sendData(arrayOfViewModel: Array<VSViewModelVogue>, error: Error?) {
        
        if error == nil {
            
            for model in arrayOfViewModel{
                if model.is_Dashoboard! {
                    arrayModelVogueDashboard.append(model)
                }
            }
            
            for model in arrayOfViewModel{
                if model.is_Shop! {
                    arrayModelVogueShop.append(model)
                }
            }
            
            for model in arrayOfViewModel{
                if model.is_Featured! {
                    modelVogueFeatured = model
                }
            }
            
            DispatchQueue.main.async {
                self.hideIndicator()
                self.performSegue(withIdentifier: "segID_VSDashboardVC", sender: nil)
            }
        }else {
            hideViewTouchID(true)
            self.hideIndicator()
            self.popupAlert(title: "Error", message: error?.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
                }, nil])
        }
    }
}

extension VSLoginVC: NVActivityIndicatorViewable {
    
    // MARK:-- Activity Indicator Protocol Delegation
    
    func showIndicator() {
        let size = CGSize(width: 70, height: 70)
        
        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 22), fadeInAnimation: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Fetching loyalty Points...")
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.stopAnimating(nil)
        }
    }
}
