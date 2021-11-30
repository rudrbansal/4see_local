//
//  forgetPasswordVC.swift
//  4See
//
//  Created by Gagan Arora on 22/03/21.
//

import UIKit
import SwiftValidator
class forgetPasswordVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "forgetPasswordVC"
    }
    
    @IBOutlet weak var emailTFT: UITextField!
    var viewModel = LoginViewModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
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
extension forgetPasswordVC : ValidationDelegate {
 
    func validationSuccessful() {
        if emailTFT.text == ""
        {
            self.showToast("Email field is required.")
        }
        else
        {
            self.forgetPasswordAPI()
        }
    }

    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        if let errorMessage = errors.first?.1.errorMessage {
            super.showToast(errorMessage)
        }
    }
}
extension forgetPasswordVC {
func forgetPasswordAPI() {
        super.showProgressBar()
        viewModel.setForgetPasswordValues(emailTFT.text!)
        viewModel.forgetPassword { (status, message) in
            super.hideProgressBar()
            if status {
                print(message)
                self.emailTFT.text = ""
                self.showToast(message)
            } else {
                self.showToast(message)
            }
        }
    }
    
   
}
