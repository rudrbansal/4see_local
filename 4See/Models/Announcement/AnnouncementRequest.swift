//
//  AnnouncementRequest.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation
import Alamofire

class AnnouncementRequest: BaseRequest {
    
    static let shared = AnnouncementRequest()

    //MARK: - Get Announcements List
    func announcementsAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ANNOUNCEMENTS_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetAnnouncements)
    }
  
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = AnnouncementResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)
        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
