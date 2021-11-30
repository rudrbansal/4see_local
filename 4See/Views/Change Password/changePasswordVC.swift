//
//  changePasswordVC.swift
//  4See
//
//  Created by Gagan Arora on 22/03/21.
//

import UIKit
import SwiftValidator

class changePasswordVC: BaseViewController {
    override class var storyboardIdentifier: String
    {
        return "changePasswordVC"
    }
    @IBOutlet weak var oldPassTFT: UITextField!
    @IBOutlet weak var newPassTFT: UITextField!
    @IBOutlet weak var confirmTFT: UITextField!
    
    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        oldPassTFT.setPlaceholder("Old Password", withColor: BaseColors.themeColor)
        newPassTFT.setPlaceholder("New Password", withColor: BaseColors.themeColor)
        confirmTFT.setPlaceholder("Confirm Password", withColor: BaseColors.themeColor)

    }
    @IBAction func sendAction(_ sender: Any)
    {
        validator.validate(self)
    }
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
}
// ValidationDelegate Methods
extension changePasswordVC : ValidationDelegate {
 
    func validationSuccessful() {
        if oldPassTFT.text == "" && newPassTFT.text == "",confirmTFT.text == ""
        {
            self.showToast("All fields are required.")
        }
        else if oldPassTFT.text == ""
        {
            self.showToast("Old password field required.")
        }
        else if newPassTFT.text == ""
        {
            self.showToast("New password field required.")
        }
        else if confirmTFT.text == ""
        {
            self.showToast("Confirm Password field required.")
        }

        else
        {
            self.changePasswordAPI()
        }
    }

    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        if let errorMessage = errors.first?.1.errorMessage {
            super.showToast(errorMessage)
        }
    }
}
extension changePasswordVC {
func changePasswordAPI() {
        super.showProgressBar()
        viewModel.setChangePasswordValues(oldPassTFT.text!,newPassTFT.text!)
        viewModel.changePassword { (status, message) in
            super.hideProgressBar()
            if status == true {
                print(message)
                self.showToast(message)
                self.oldPassTFT.text = ""
                self.newPassTFT.text = ""
                self.confirmTFT.text = ""

            } else {
                self.showToast(message)
            }
        }
    }
    
   
}
