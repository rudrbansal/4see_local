//
//  editProfileHandler.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import Foundation

class editProfileHandler {
    
    static let `default` = editProfileHandler()
    var phone = ""
    var email = ""
    var address = ""
    var vechileNumber = ""
    var gender = ""
    var imageData = [Data]() //imageData
    var geoLocaton = ""
    var alramTime = ""
    var notification = ""
}

extension editProfileHandler {
    
    /// Create JSON Object
    func editProfileObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["phone": phone,
                                         "email": email,
                                         "vechileNumber": vechileNumber,
                                         "address": address,
                                         "gender": gender]
        return dictionary as [String : AnyObject]
    }
    
    /// Create JSON Object
    func editProfileLocationObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["geoLocaton": geoLocaton]
        return dictionary as [String : AnyObject]
    }
    
    /// Create JSON Object
    func editProfileReminderObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["alramTime": alramTime,
                                         "notification":notification]
        return dictionary as [String : AnyObject]
    }
    
}
