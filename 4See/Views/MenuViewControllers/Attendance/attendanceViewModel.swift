//
//  attendanceViewModel.swift
//  4See
//
//  Created by Gagan Arora on 30/03/21.
//

import Foundation
import UIKit

class attendanceViewModel {

    typealias attendanceAPICallback = (Bool,String) -> Void
    var completion : attendanceAPICallback?
    var attendList = [AttendanceModel]()
    var breakList = [AttendanceModel]()
    var regList =  [RegisterModel]()
    var monthArr = [String]()
    var regFilterList =  [RegisterModel]()
    var uniqList =  [RegisterModel]()
    var regNewFilterList =  [RegisterModel]()
    var uniqnewList =  [RegisterModel]()

    var attachments = [UIImage]()
    var checkInList = [CheckInModel]()
    var checkInReverseList = [CheckInModel]()
    var timee: Int!
    var breakArr = [Int]()
    var breakOutArr = [Int]()
    var breakkList = [CheckInModel]()
    var Breaktimee: Int!
    var clockedOutList = [AttendanceModel]()
    var holidaysList = [AttendanceModel]()
    
    var checkOutList = [CheckInModel]()

    var checkOuttimee: Int!

    var attendanceType = ""
    var attendanceCheckInType = ""
    
    func getAttendanceListAPI(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.attendanceListAPI(delegate: self)
    }
    //MARK:- Add Attendance API
    func setAttendanceValues(_ id: String,_ datee:String)
    {
        attendanceHandler.default.id = id
        attendanceHandler.default.date = datee
        attendanceHandler.default.lat = "30.7046"
        attendanceHandler.default.lng = "76.7179"

        attendanceHandler.default.type = attendanceType
        attendanceHandler.default.chekcIntype = attendanceCheckInType

    }
    
    func addAttendApi(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.addAttendanceAPI(paramaters: attendanceHandler.default.addAttendanceObjectJSON(), delegate: self)
    }
    //MARK:- Filter Attendance API
    func setfilterAttendanceValues(_ startDate: String,_ endDate:String)
    {
        attendanceHandler.default.startDate = startDate
        attendanceHandler.default.endDate = endDate
    }
    
    func addFilterAttendApi(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.addFilterAttendanceAPI(paramaters: attendanceHandler.default.filterObjectJSON(), delegate: self)
    }
    //MARK:- Running Late API
    func setLateValues(_ id: String,_ datee:String,_ type:String,_ time: String,_ reason: String,_ message:String)
    {
        attendanceHandler.default.id = id
        attendanceHandler.default.lat = "30.7046"
        attendanceHandler.default.lng = "76.7179"
        attendanceHandler.default.date = datee
        attendanceHandler.default.message = message
        attendanceHandler.default.reason = reason
        attendanceHandler.default.time = time
        attendanceHandler.default.type = type

    }
    func lateAttendApi(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.addAttendanceAPI(paramaters: attendanceHandler.default.runningLateObjectJSON(), delegate: self)
    }
    func convertMonth(date:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: date)
        formatter.dateFormat = "MMMM"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func localDate() -> Date {
          let nowUTC = Date()
          let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
          guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

          return localDate
      }
    //MARK:- Get Attendance Details API
    func setAttendanceDetailsValues(_ startDate:String,_ endDate:String)
    {
        attendanceHandler.default.startDate = startDate
        attendanceHandler.default.endDate = endDate
    }
    
    func getAttendanceDetailsApi(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.attendanceDetailsAPI(paramaters: attendanceHandler.default.detailsObjectJSON(), delegate: self)
    }
    
    func getListHolidaysDetails(completion: @escaping attendanceAPICallback) {
        self.completion = completion
        AttendanceRequest.shared.listHolidayAPI(delegate: self)
    }
    
}

extension attendanceViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
        if response.requestType == APIRequests.RType_GetAttendanceList {
            let data = response.serverData["payload"] as? [String:Any]
            if let responseData = data!["data"] as? [[String:Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    attendList = try JSONDecoder().decode([AttendanceModel].self, from: jsonData)
                    
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(attendList)
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
        else if response.requestType == APIRequests.RType_AddAttendance {
            let data = response.serverData["message"] as? String
            print(data!)
            completion?(true, data!)
        }
        else if response.requestType == APIRequests.RType_FilterAttendance {
            let data = response.serverData["payload"] as? [String:Any]
            if let responseData = data!["data"] as? [[String:Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    regList = try JSONDecoder().decode([RegisterModel].self, from: jsonData)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(regList)
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false, data!)
                }
            }
        }
        else if response.requestType == APIRequests.RType_AttendanceDetails {
            let data = response.serverData["payload"] as? [String:Any]
            if let responseData = data!["data"] as? [[String:Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    checkInList = try JSONDecoder().decode([CheckInModel].self, from: jsonData)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(checkInList)
                    
                    
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false, data!)
                }
            }
        }
        else if response.requestType == APIRequests.RType_GetListHoliDays {
            let data = response.serverData["payload"] as? [String:Any]
            if let responseData = data!["data"] as? [[String:Any]] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    holidaysList = try JSONDecoder().decode([AttendanceModel].self, from: jsonData)
                    
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(attendList)
                }
                catch (let error) {
                    print(error)
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
        completion?(false, response.message)
    }
    
}
