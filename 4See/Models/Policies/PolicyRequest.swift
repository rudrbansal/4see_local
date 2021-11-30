//
//  PolicyRequest.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import Foundation
import Alamofire

class PolicyRequest: BaseRequest {
    
    static let shared = PolicyRequest()

    //MARK: - Get Policies List
    func policyListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.POLICY_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetPoliciesList)
    }
   
 
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = PolicyResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)

        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
