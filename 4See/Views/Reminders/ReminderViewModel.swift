//
//  ReminderViewModel.swift
//  4See
//
//  Created by Sahil Garg on 15/05/21.
//

import UIKit

class ReminderViewModel {

    func setValues(_ alramTime:String) {
        editProfileHandler.default.notification = "on"
        editProfileHandler.default.alramTime = alramTime
    }

    func updateProfileAlarmAPI() {
        UserRequest.shared.editprofile(paramaters: editProfileHandler.default.editProfileReminderObject(), imageData: [], delegate: self)
    }
    
}

extension ReminderViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
        
        if response.requestType == APIRequests.RType_EditProfile {
            if let responseData = response.serverData["payload"] as? NSDictionary, let dataa = responseData.value(forKey: "userInfo") as? NSDictionary {
                UserDefaults.standard.setValue(dataa.value(forKey: "notification")!, forKey: "notification")
                UserDefaults.standard.setValue(dataa.value(forKey: "alramTime")!, forKey: "alramTime")
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
