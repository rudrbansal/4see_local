//
//  biometricsVC.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu
import LocalAuthentication

class biometricsVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "biometricsVC"
    }
    @IBOutlet weak var topTittle: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var clockInView: UIView!
    @IBOutlet weak var thanksVW: UIView!
    @IBOutlet weak var bannerImg: UIImageView!
    var type = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        biomatrics()
        viewTransition()
    }
    func check()
    {
        if GlobalVariable.dismiss == "dismiss_reminder"
        {
            thanksVW.isHidden = false
            clockInView.isHidden = true
        }
        else
        {
            thanksVW.isHidden = true
            clockInView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        check()
    }
    func viewTransition()
    {
        check()
            if type == "Attendance"
            {
                topTittle.text = "Work Attendance"
                bannerImg.image = UIImage(named: "bioMatric_banner")
                thanksVW.isHidden = true
                clockInView.isHidden = false
            }
            else if type == "Work From Home"
            {
                topTittle.text = "Work From Home"
                titleLbl.text = "Work Attendance"
                bannerImg.image = UIImage(named: "wfh_banner")
                thanksVW.isHidden = true
                clockInView.isHidden = false
                
            }
    
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    func permissions()
    {
        let alert = UIAlertController(title: "4See ", message: "Please add your biometric authntication to move further.", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "ADD", style: .default, handler: { action in
            self.biomatrics()
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func biomatrics()
    {
        let myContext = LAContext()
        var authError: NSError?
        let myLocalizedReasonString = "Biometric Authntication !! "
        
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    DispatchQueue.main.async {
                        if (myContext.biometryType == LABiometryType.faceID)
                        {
                            if self.type == "Work From Home"
                            {
                                let objc = remindersVC()
                                objc.type = "Work From Home"
                                objc.viewModel.attendanceType = "1"
                                objc.viewModel.attendanceCheckInType = "HomeCheckIn"
                                self.navigationController?.pushViewController(objc)
                            }
                            else
                            {
                                let objc = remindersVC()
                                objc.type = "Attendance"
                                objc.viewModel.attendanceType = "0"
                                objc.viewModel.attendanceCheckInType = "CheckIn"
                                self.navigationController?.pushViewController(objc)
                            }
                            
                        } else if myContext.biometryType == LABiometryType.touchID
                        {
                            if self.type == "Work From Home"
                            {
                                let objc = remindersVC()
                                objc.type = "Work From Home"
                                objc.viewModel.attendanceType = "1"
                                objc.viewModel.attendanceCheckInType = "HomeCheckIn"
                                self.navigationController?.pushViewController(objc)
                            }
                            else
                            {
                                let objc = remindersVC()
                                objc.viewModel.attendanceType = "0"
                                objc.viewModel.attendanceCheckInType = "CheckIn"
                                objc.type = "Attendance"
                                
                                self.navigationController?.pushViewController(objc)
                            }
                        }
                        else {
                            // Device cannot use biometric authentication
                            if let err = authError {
                                switch err.code{
                                
                                case LAError.Code.biometryNotEnrolled.rawValue:
                                    self.notifyUser("User is not enrolled",
                                                    err: err.localizedDescription)
                                    
                                case LAError.Code.passcodeNotSet.rawValue:
                                    self.notifyUser("A passcode has not been set",
                                                    err: err.localizedDescription)
                                    
                                    
                                case LAError.Code.biometryNotAvailable.rawValue:
                                    self.notifyUser("Biometric authentication not available",
                                                    err: err.localizedDescription)
                                default:
                                    self.notifyUser("Unknown error",
                                                    err: err.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                self.showToast("Ooops!!.. This feature is not supported.")
                
            }
        }
        else {
            // Fallback on earlier versions
            self.showToast("Ooops!!.. This feature is not supported.")
            
        }
    }
    func notifyUser(_ msg: String, err: String?)
    {
            let alert = UIAlertController(title: msg,
                message: err,
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)

            alert.addAction(cancelAction)

            self.present(alert, animated: true,
                                completion: nil)
        }
    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
}
