//
//  SickHandler.swift
//  4See
//
//  Created by Gagan Arora on 01/04/21.
//

import Foundation
import UIKit

class SickHandler {
    static let `default` = SickHandler()
    var date = ""
    var reason = ""
    var message = ""
    var duration = ""
    var isCovid = ""
    var covidNotificaton = ""
    var imageData = [Data]()
    
}

extension SickHandler {
    
    /// Create JSON Object
    func applyLeaveObjectJSON() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["date": date,
                                         "reason": reason,
                                         "message":message,
                                         "duration": duration,
                                         "isCovid":isCovid,
                                         "covidNotificaton": covidNotificaton]
        return dictionary as [String : AnyObject]
    }
   
}
