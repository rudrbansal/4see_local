//
//  UserRequest.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import Foundation
import Alamofire

class UserRequest: BaseRequest {
    
    static let shared = UserRequest()

    //MARK: - Log In
    func postLogIn(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LOGIN
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Login)
    }
    //MARK: - Logout
    func LogoutAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LOGOUT
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Logout)
    }
    //MARK: - Edit User Profile
    func editprofile(paramaters:[String: AnyObject],imageData: [Data?]?,delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.UPDATE_PROFILE
        super.sendRequestWithImage(imageDataArray: imageData, fileName: "upload", parameters: (paramaters as AnyObject) as! [String : Any], header: AppConfig.authToken, url: url, type: RequestType.RType_Put, request: APIRequests.RType_EditProfile)
    }
    //MARK: - Forget Password
    func forgetPassword(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.FORGET_PASSWORD
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_ForgetPassword)
    }
    //MARK: - Change Password
    func changePassword(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.CHANGE_PASSWORD
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Put, request: APIRequests.RType_ChangePassword)
    }
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = UserResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)
        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
