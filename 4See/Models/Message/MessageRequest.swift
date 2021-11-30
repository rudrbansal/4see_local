//
//  MessageRequest.swift
//  4See
//
//  Created by Gagan Arora on 19/04/21.
//

import Foundation
import Alamofire

class MessageRequest: BaseRequest {
    
    static let shared = MessageRequest()

    //MARK: - Get Message List
    func msgsListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LIST_MESSAGES
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetMsgsList)
    }
    //MARK: - Get Boss Message List
    func bossMessgesListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LIST_BOSSMESSAGES
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetBossMsgsList)
    }
    //MARK: - Add Message API
    func addMessageAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ADD_MESSAGE
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_AddMessage)
    }
    //MARK: - Favourite Message API
    func addFavouriteMsgAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.FAVOURITE_MESSAGE
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_FavouriteMsg)
    }
    //MARK: -  Message Details API
    func msgDetailsAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.MESSAGE_DETAILS+GlobalVariable.messageId
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_MsgDetails)
    }
    //MARK: -  Message Delete API
    func msgDeleteAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.MESSAGE_DELETE
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_MsgDelete)
    }
    //MARK: -  Message Sent API
    func sentMsgsListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LIST_SENT_MESSAGES
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_MsgSent)
    }
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = MessageResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)

        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
