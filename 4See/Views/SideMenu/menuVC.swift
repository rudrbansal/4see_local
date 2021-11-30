//
//  menuVC.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class menuVC: UIViewController {
    var viewModel = LoginViewModel()
    
    //    @IBOutlet weak var logoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UrlConfig.IMAGE_URL+(AppConfig.loggedInUser!.userInfo!.companyId!.image!))
//        logoImg.setImageOnView(UrlConfig.IMAGE_URL+AppConfig.loggedInUser!.userInfo!.companyId!.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    }
    
    @IBAction func changePassBtn(_ sender: Any) {
        let objc = changePasswordVC()
        self.navigationController?.pushViewController(objc)
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
        switch (sender as AnyObject).tag{
        case 1:
            let objc = HomeViewController()
            self.navigationController?.pushViewController(objc)
        case 2:
            let objc = attendanceVC()
            self.navigationController?.pushViewController(objc)
//            let objc = toolsTradeViewController()
//            self.navigationController?.pushViewController(objc)
        case 3:
            let objc = attendanceVC()
            self.navigationController?.pushViewController(objc)
        case 4:
            let objc = messageVC()
            self.navigationController?.pushViewController(objc)
        case 5:
            let objc = policiesVC()
            self.navigationController?.pushViewController(objc)
        case 6:
            let alertController = UIAlertController(title: "4See", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let btnYes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                self.userLogout()
            }
            let btnCancel = UIAlertAction(title: "Cancel", style: .default)
            { (action:UIAlertAction!) in
                
            }
            alertController.addAction(btnYes)
            alertController.addAction(btnCancel)
            self.present(alertController, animated: true, completion:nil)
            
        default:
            print("No Button Selected")
            
        }
    }
}
extension menuVC {
    func userLogout() {
        viewModel.logout { (status, message) in
            if status {
                Global.userLogOut()
            } else {
            }
        }
    }
}
