//
//  LeaveRequest.swift
//  4See
//
//  Created by Gagan Arora on 01/04/21.
//

import Foundation
import Alamofire

class LeaveRequest: BaseRequest {
    
    static let shared = LeaveRequest()

    //MARK: - Get Leaves List
    func leavesListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.SICK_LEAVE_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetLeavesList)
    }
   
    //MARK: - Apply Leave API
    func applyLeaveAPI(paramaters:[String: AnyObject],imageData: [Data?]?,delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.APPLY_LEAVE
        super.sendRequestWithImage(imageDataArray: imageData, fileName: "document", parameters: (paramaters as AnyObject) as! [String : Any], header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Applyleave)
    }
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = LeaveResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)

        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
