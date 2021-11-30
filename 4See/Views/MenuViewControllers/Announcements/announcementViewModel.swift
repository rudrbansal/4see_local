//
//  announcementViewModel.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation

import UIKit

class announcementViewModel {

    typealias announcementAPICallback = (Bool,String) -> Void
    var completion : announcementAPICallback?
    var announcementsList : AnnouncementModel?
    var details : infoList?
    func getAnnouncementsAPI(completion: @escaping announcementAPICallback) {
        self.completion = completion
        AnnouncementRequest.shared.announcementsAPI(delegate: self)
    }
    
}

extension announcementViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_GetAnnouncements {
                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        announcementsList = try JSONDecoder().decode(AnnouncementModel.self, from: jsonData)
                        completion?(true,"")
                        print(announcementsList)
                    }
                    catch {
                        failureWithdata(response: response)
                        completion?(false,response.message)

                    }
                }
                 else {
                    failureWithdata(response: response)
                    completion?(false,response.message)

                }
            }
         else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        completion?(false,response.message)
    }
    
}
