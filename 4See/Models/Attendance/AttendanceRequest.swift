//
//  AttendanceRequest.swift
//  4See
//
//  Created by Gagan Arora on 30/03/21.
//

import Foundation
import Alamofire

class AttendanceRequest: BaseRequest {
    
    static let shared = AttendanceRequest()

    //MARK: - Get Systems List
    func attendanceListAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ATTENDANCE_LIST
        super.sendRequestWithJson(dataObject: nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetAttendanceList)
    }
    //MARK: - Add Attendance
    func addAttendanceAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ADD_ATTENDANCE
        super.sendRequestWithJson(dataObject:  paramaters as AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_AddAttendance)
    }
    //MARK: - Add Attendance
    func addFilterAttendanceAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.FILTER_ATTENDANCE
        super.sendRequestWithJson(dataObject:  paramaters as AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_FilterAttendance)
    }
    //MARK: -  Attendance Details API
    func attendanceDetailsAPI(paramaters:[String: AnyObject],delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.ATTENDANCE_DETAILS
        super.sendRequestWithJson(dataObject:  paramaters as AnyObject, header: AppConfig.authToken, url: url, type: RequestType.RType_Post, request: APIRequests.RType_AttendanceDetails)
    }
    //MARK: - List Holiday Details API
    func listHolidayAPI(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL+UrlConfig.LIST_HOLIDAYS
        super.sendRequestWithJson(dataObject:  nil, header: AppConfig.authToken, url: url, type: RequestType.RType_Get, request: APIRequests.RType_GetListHoliDays)
    }
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = AttendanceResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)
        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
