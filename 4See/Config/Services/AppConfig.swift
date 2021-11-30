//
//  AppConfig.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import Foundation
import UIKit
enum APIRequests : Int {
    case RType_Login
    case RType_Logout
    case RType_ForgetPassword
    case RType_EditProfile
    case RType_ChangePassword
    case RType_GetAnnouncements
    case RType_GetSystems
    case RType_AddSystem
    case RType_GetAttendanceList
    case RType_AddAttendance
    case RType_GetLeavesList
    case RType_Applyleave
    case RType_GetPoliciesList
    case RType_GetNotesList
    case RType_AddNote
    case RType_EditNote
    case RType_GetMsgsList
    case RType_GetBossMsgsList
    case RType_AddMessage
    case RType_FilterAttendance
    case RType_FavouriteMsg
    case RType_MsgDetails
    case RType_AttendanceDetails
    case RType_GetListHoliDays
    case RType_MsgDelete
    case RType_MsgSent
}

enum RequestType: Int {
    case RType_Get
    case RType_Post
    case RType_Put
    case RType_Delete
}

struct ServiceStatusCode {
    static let kSuccess             =  200
    static let kSuccessRegister     =  201
    static let kUserAlreadyExist    =  400
    static let kAuthorizationError  =  401
    static let kError               =  404
}

class AppConfig {
    
    static var deviceToken = "abcd"
    static var deviceType = "iOS"
    static var loggedInUser : UserModel?
    static var profileImage : UIImage?
    static var type : String!
    static var loginType : String!
    static var segmentType : String!
    static var trailsType : String!
    static var breakTime : String!
    static var totalTime : String!
    static var regData = [RegisterModel]()
    static var checkOutTime : String!

    static let placeHolder = UIImage(named: "logo")

    static let defaultCountry = CountrySelectModel(name: "India", countryCode: "IN", phoneCode: "+91")
    static var authToken: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultsKey.authToken.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.authToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var isGuestUser : Bool {
        get {
            return authToken.isEmpty
        }
    }
}
