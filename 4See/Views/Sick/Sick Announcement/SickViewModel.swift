//
//  SickViewModel.swift
//  4See
//
//  Created by Gagan Arora on 01/04/21.
//
import Foundation
import UIKit


class SickViewModel {

    typealias leavesAPICallback = (Bool,String) -> Void
    var completion : leavesAPICallback?
    var leavesList: LeaveModel?
    var selectedLeaveInfo : leaveInfo?
    var attachments = [UIImage]()

    
    func gettLeavesAPI(completion: @escaping leavesAPICallback) {
        self.completion = completion
        LeaveRequest.shared.leavesListAPI(delegate: self)
    }
    //MARK:- Add System API
   
    func setApplyLeaveValues(_ date: String,_ reason:String,_ message:String,_ duration:String,_ isCovid:String,_ covidNotificaton:String)
    {
        SickHandler.default.date = date
        SickHandler.default.reason = reason
        SickHandler.default.message = message
        SickHandler.default.duration = duration
        SickHandler.default.isCovid = isCovid
        SickHandler.default.covidNotificaton = covidNotificaton
        SickHandler.default.imageData.removeAll()
       
    }
    
    func applyLeaveApi(completion: @escaping leavesAPICallback) {
        self.completion = completion
            for attachment in attachments {
                if let imageData = attachment.jpegData(compressionQuality: 0.6) {
                    SickHandler.default.imageData.append(imageData)
                }
            }
        LeaveRequest.shared.applyLeaveAPI(paramaters: SickHandler.default.applyLeaveObjectJSON(), imageData: SickHandler.default.imageData, delegate: self)

    }
}

extension SickViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_GetLeavesList {
                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        leavesList = try JSONDecoder().decode(LeaveModel.self, from: jsonData)
                        let data = response.serverData["message"] as? String
                        print(data!)
                        completion?(true, data!)
                        print(leavesList)
                    }
                    catch {
                        failureWithdata(response: response)
                        let data = response.serverData["message"] as? String
                        print(data!)
                        completion?(false, data!)
                    }
                }
                 else {
                    failureWithdata(response: response)
                }
            }
        else if response.requestType == APIRequests.RType_Applyleave {
            print(response.serverData)
                do {
                        let data = response.serverData["message"] as? String
                        print(data!)
                        completion?(true,data!)
                        print(leavesList)
                }
                catch {
                    let data = response.serverData["message"] as? String
                    print(data!)
                    failureWithdata(response: response)
                    completion?(false,data!)

                }
        }

         else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        failureWithdata(response: response)
    }
    
}
