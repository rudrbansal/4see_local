//
//  attendanceHandler.swift
//  4See
//
//  Created by Gagan Arora on 30/03/21.
//

import Foundation
import UIKit

class attendanceHandler {
    static let `default` = attendanceHandler()
    var id = ""
    var date = ""
    var lat = ""
    var lng = ""
    var time = ""
    var message = ""
    var reason = ""
    var startDate = ""
    var endDate = ""

    var location: [String: Any] {
        var dict = [String: Any]()
        dict["lat"] = lat
        dict["lng"] = lng
        return dict
    }
    var type = ""
    var chekcIntype = ""
}

extension attendanceHandler {
    
    /// Create JSON Object
    func addAttendanceObjectJSON() -> [String: AnyObject] {
      
        var dictionary: [String: Any] = ["date": date,
                                         "lat":lat,
                                         "location":location,
                                         "type": type,
                                         "chekcIntype":chekcIntype]
        return dictionary as [String : AnyObject]
    }
    func runningLateObjectJSON() -> [String: AnyObject] {
      
        var dictionary: [String: Any] = ["date": date,
                                         "lat":lat,
                                         "lateHours":time,
                                         "message":message,
                                         "reason":reason,
                                         "location":location,
                                         "type": type]
        return dictionary as [String : AnyObject]
    }
    func filterObjectJSON() -> [String: AnyObject] {
      
        var dictionary: [String: Any] = ["startDate": startDate,
                                         "endDate":endDate]
        return dictionary as [String : AnyObject]
    }
    func detailsObjectJSON() -> [String: AnyObject] {
      
        var dictionary: [String: Any] = ["startDate": startDate,
                                         "endDate":endDate]
        return dictionary as [String : AnyObject]
    }
}
