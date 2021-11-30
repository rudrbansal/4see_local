//
//  HomeViewModel.swift
//  4See
//
//  Created by Sahil Garg on 15/05/21.
//

import Foundation

class HomeViewModel {
   
    func setValues(_ geoLocaton:Bool) {
        editProfileHandler.default.geoLocaton = geoLocaton ? "on" : "off"
    }

    func updateProfileAPI() {
        UserRequest.shared.editprofile(paramaters: editProfileHandler.default.editProfileLocationObject(), imageData: [], delegate: self)
    }
    
}

extension HomeViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
        
        if response.requestType == APIRequests.RType_EditProfile {
            if let responseData = response.serverData["payload"] as? NSDictionary, let dataa = responseData.value(forKey: "userInfo") as? NSDictionary {
                UserDefaults.standard.setValue(dataa.value(forKey: "geoLocaton")!, forKey: "geoLocaton")
            } else {
                failureWithdata(response: response)
            }
        }
        else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        
    }
    
}
