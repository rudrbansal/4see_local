//
//  NotesRequest.swift
//  4See
//
//  Created by Gagan Arora on 13/04/21.
//

import Foundation
import Alamofire

class NotesRequest: BaseRequest {
    
    static let shared = NotesRequest()

    //MARK: - Get Notes List
    func notesListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.NOTE_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetNotesList)
    }
    //MARK: - Add Note
    func addNoteAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ADD_NOTE
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_AddNote)
    }
    //MARK: - Edit Note
    func editNoteAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ADD_NOTE
        super.sendRequestWithJson(dataObject: paramaters as! AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_EditNote)
    }
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = NotesResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)

        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
