//
//  LoginViewModel.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit

class LoginViewModel {

    typealias LoginAPICallback = (Bool,String) -> Void
    var completion : LoginAPICallback?
    var userinfoDetails : UserModel?
    
    func setValues(_ userName:String,_ password:String) {
        LoginHandler.default.username = userName
        LoginHandler.default.password = password
    }
    
    func loginUser(_ completion: @escaping LoginAPICallback) {
        self.completion = completion
        UserRequest.shared.postLogIn(paramaters: LoginHandler.default.getLoginObject(), delegate: self)
    }
    func logout(_ completion: @escaping LoginAPICallback) {
        self.completion = completion
        UserRequest.shared.LogoutAPI(delegate: self)
    }
    //MARK:- Forget Password.....//
    
    func setForgetPasswordValues(_ email:String) {
        LoginHandler.default.email = email
    }
    func forgetPassword(_ completion: @escaping LoginAPICallback) {
        self.completion = completion
        UserRequest.shared.forgetPassword(paramaters: LoginHandler.default.getforgetPasswordObject(), delegate: self)
    }
    //MARK:- Change Password.....//
    
    func setChangePasswordValues(_ oldPassword:String,_ newPassword:String) {
        LoginHandler.default.oldPassword = oldPassword
        LoginHandler.default.newPassword = newPassword
    }
    func changePassword(_ completion: @escaping LoginAPICallback) {
        self.completion = completion
        UserRequest.shared.changePassword(paramaters: LoginHandler.default.getChangePasswordObject(), delegate: self)
    }
}

extension LoginViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_Login {

                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        AppConfig.loggedInUser = try JSONDecoder().decode(UserModel.self, from: jsonData)
                        Global.saveDataInUserDefaults(.userData)
                        print(AppConfig.loggedInUser?.userInfo)
                        UserDefaults.standard.setValue(AppConfig.loggedInUser?.userInfo?.email, forKey: "email")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser?.userInfo?.phone, forKey: "phone")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser?.userInfo?.address, forKey: "address")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.image, forKey: "image")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.jobTitle, forKey: "jobTitle")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.gender, forKey: "gender")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.vechileNumber ?? "Vehicle Registration", forKey: "vechileNumber")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.geoLocaton, forKey: "geoLocaton")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.alramTime, forKey: "alramTime")
                        UserDefaults.standard.setValue(AppConfig.loggedInUser!.userInfo!.notification, forKey: "notification")
                        print(AppConfig.loggedInUser?.userInfo)
                        AppConfig.authToken = AppConfig.loggedInUser!.token!
                        completion?(true,"")
                        UserDefaults.standard.set(true, forKey: "USERISLOGIN")

                    }
                    catch {
                        failureWithdata(response: response)
                    }
                } else {
                    failureWithdata(response: response)
                }
            }
            else if response.requestType == APIRequests.RType_Logout
            {
                completion?(true,response.message)

            }
            else if response.requestType == APIRequests.RType_ForgetPassword
            {
                let data = response.serverData["message"] as? String
                print(data!)

                completion?(true,data!)

            }
            else if response.requestType == APIRequests.RType_ChangePassword
            {
                let data = response.serverData["message"] as? String
                print(data!)

                completion?(true,data!)

            }
         else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        completion?(false,response.message)
    }
    
}
