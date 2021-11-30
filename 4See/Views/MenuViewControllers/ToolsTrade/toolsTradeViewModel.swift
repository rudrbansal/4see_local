//
//  toolsTradeViewModel.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation
import UIKit


class toolsTradeViewModel {

    typealias toolsAPICallback = (Bool,String) -> Void
    var completion : toolsAPICallback?
    var systemsList: SystemModel?
    var selectedSystemInfo : sytemsInfo?
    var attachments = [UIImage]()

    
    func getSystemsAPI(completion: @escaping toolsAPICallback) {
        self.completion = completion
        SystemRequest.shared.systemsAPI(delegate: self)
    }
    //MARK:- Add System API
    func setEditValues(_ id: String,_ titlee:String,_ seriallNumber:String)
    {
        toolsTradeHandler.default.id = id
        toolsTradeHandler.default.title = titlee
        toolsTradeHandler.default.serialNumber = seriallNumber
        toolsTradeHandler.default.imageData.removeAll()
       
    }
    
    func addSystemApi(completion: @escaping toolsAPICallback) {
        self.completion = completion
        print(attachments)
        if attachments.count != 0
        {
            for attachment in attachments {
                if let imageData = attachment.jpegData(compressionQuality: 0.6) {
                    toolsTradeHandler.default.imageData.append(imageData)
                    SystemRequest.shared.addSystemsAPI(paramaters: toolsTradeHandler.default.addSystemObjectJSON(), imageData: toolsTradeHandler.default.imageData, delegate: self)
                }
            
            }
        }
        else
        {
            SystemRequest.shared.addSystemsAPI(paramaters: toolsTradeHandler.default.addSystemObjectJSON(), imageData: [], delegate: self)

        }       
            
    }
}

extension toolsTradeViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_GetSystems {
                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        systemsList = try JSONDecoder().decode(SystemModel.self, from: jsonData)
                        
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
                }
                 else {
                    failureWithdata(response: response)
                }
            }
        if response.requestType == APIRequests.RType_AddSystem {
            if let responseData = response.serverData["payload"] as? [String:Any] {
                do {
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
            }
             else {
                failureWithdata(response: response)
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
