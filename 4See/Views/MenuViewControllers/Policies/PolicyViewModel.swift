//
//  PolicyViewModel.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import Foundation
import UIKit


class PolicyViewModel {

    typealias policiesAPICallback = (Bool,String) -> Void
    var completion : policiesAPICallback?
    var policiesList: PolicyModel?
    var selectedLeaveInfo : policyInfo?

    func getPoliciesAPI(completion: @escaping policiesAPICallback) {
        self.completion = completion
        PolicyRequest.shared.policyListAPI(delegate: self)
    }
 
}

extension PolicyViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_GetPoliciesList {
                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        policiesList = try JSONDecoder().decode(PolicyModel.self, from: jsonData)
                        let data = response.serverData["message"] as? String
                        print(data!)
                        completion?(true, data!)
                        print(policiesList)
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

         else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        failureWithdata(response: response)
    }
    
}
