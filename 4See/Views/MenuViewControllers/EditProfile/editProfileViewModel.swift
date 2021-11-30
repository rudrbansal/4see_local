//
//  editProfileViewModel.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit

class editProfileViewModel {

    typealias profileAPICallback = (Bool,String) -> Void
    var completion : profileAPICallback?
    var attachments = [UIImage]()
    var info : ProfileModel?
    var gender = "Male"
    
    func setValues(_ email:String,_ phone:String,_ address: String,_ vehicleNumber:String) {
        editProfileHandler.default.email = email
        editProfileHandler.default.phone = phone
        editProfileHandler.default.address = address
        editProfileHandler.default.vechileNumber = vehicleNumber
        editProfileHandler.default.gender = gender
    }
    
    func updateProfileAPI(completion: @escaping profileAPICallback) {
        self.completion = completion
        if attachments.count != 0
        {
            for attachment in attachments {
                if let imageData = attachment.jpegData(compressionQuality: 0.6) {
                    editProfileHandler.default.imageData.append(imageData)
                    UserRequest.shared.editprofile(paramaters: editProfileHandler.default.editProfileObject(), imageData: [imageData], delegate: self)
                }
            
            }
        }
        else
        {
            UserRequest.shared.editprofile(paramaters: editProfileHandler.default.editProfileObject(), imageData: [], delegate: self)

        }
      
    }
    
}

extension editProfileViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
        
        if response.requestType == APIRequests.RType_EditProfile {
            if let responseData = response.serverData["payload"] as? NSDictionary {
                do {
                    print(responseData)
                    let dataa = responseData.value(forKey: "userInfo") as? NSDictionary
                    print(dataa)
                    
                    UserDefaults.standard.setValue(dataa?.value(forKey: "email")!, forKey: "email")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "phone")!, forKey: "phone")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "address")!, forKey: "address")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "image")!, forKey: "image")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "vechileNumber")!, forKey: "vechileNumber")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "jobTitle")!, forKey: "jobTitle")
                    UserDefaults.standard.setValue(dataa?.value(forKey: "gender")!, forKey: "gender")
                    
                    print(UserDefaults.standard.value(forKey: "email") as! String)
                    print(UserDefaults.standard.value(forKey: "phone") as! String)
                    print(UserDefaults.standard.value(forKey: "address") as! String)
                    print(UserDefaults.standard.value(forKey: "image") as! String)
                    print(UserDefaults.standard.value(forKey: "vechileNumber") as! String)
                    
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true,data!)
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false,data!)
                    
                }
            } else {
                failureWithdata(response: response)
            }
        }
        else if response.requestType == APIRequests.RType_Logout
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
