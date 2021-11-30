//
//  SystemRequest.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation
import Alamofire

class SystemRequest: BaseRequest {
    
    static let shared = SystemRequest()

    //MARK: - Get Systems List
    func systemsAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.SYSTEMS_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetSystems)
    }
    //MARK: - Add System List
    func addSystemsAPI(paramaters:[String: AnyObject],imageData: [Data?]?,delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ADD_SYSTEM
        super.sendRequestWithImage(imageDataArray: imageData, fileName: "upload", parameters: (paramaters as AnyObject) as! [String : Any], header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_AddSystem)
    }
 
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = SystemResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)
        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
