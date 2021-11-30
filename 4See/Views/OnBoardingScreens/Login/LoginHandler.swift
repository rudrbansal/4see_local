//
//  LoginHandler.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit

class LoginHandler {

    static let `default` = LoginHandler()
    var username = ""   //username
    var password = ""  //password
    var email = ""   //email
    var oldPassword = ""   //email
    var newPassword = ""   //email


}

extension LoginHandler {
    
    /// Create JSON Object
    func getLoginObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["email": username,
                                         "password": password,
                                         "device_type":AppConfig.deviceType,
                                         "deviceToken": AppConfig.deviceToken]
        return dictionary as [String : AnyObject]
    }
    func getforgetPasswordObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["email": email]
        return dictionary as [String : AnyObject]
    }
    func getChangePasswordObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["oldpassword": oldPassword,
                                         "password": newPassword]
        return dictionary as [String : AnyObject]
    }
}
