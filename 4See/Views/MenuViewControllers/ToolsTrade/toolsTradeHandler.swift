//
//  toolsTradeHandler.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation
import UIKit

class toolsTradeHandler {
    static let `default` = toolsTradeHandler()
    var id = ""   //id
    var title = ""  //title
    var serialNumber = ""   //serial Number
    var imageData = [Data]() //imageData

}

extension toolsTradeHandler {
    
    /// Create JSON Object
    func addSystemObjectJSON() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["id": id,
                                         "title": title,
                                         "serialNumber":serialNumber]
        return dictionary as [String : AnyObject]
    }
   
}
