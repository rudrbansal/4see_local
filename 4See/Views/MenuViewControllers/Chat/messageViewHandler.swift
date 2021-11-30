//
//  messageViewHandler.swift
//  4See
//
//  Created by Gagan Arora on 19/04/21.
//

import Foundation

class messageViewHandler {

    static let `default` = messageViewHandler()
    var subject = ""
    var body = ""
    var parentId = ""
    var recipientId = ""
    var id = ""

}

extension messageViewHandler {
    
    /// Create JSON Object
    func addMsgObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["subject": subject,
                                         "body":body,
                                         "recipientId": recipientId]
        return dictionary as [String : AnyObject]
    }
    /// Create JSON Object
    func replyMsgObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["subject": subject,
                                         "body":body,
                                         "parentId": parentId,
                                         "recipientId": recipientId]
        return dictionary as [String : AnyObject]
    }
    /// Create JSON Object
    func favMsgObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["id": parentId]
        return dictionary as [String : AnyObject]
    }
    /// Create JSON Object
    func msgDetailsObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["parentId": parentId]
        return dictionary as [String : AnyObject]
    }
    func msgDeleteObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["id": id]
        return dictionary as [String : AnyObject]
    }
    func msgDeleteSentObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["id": id,"type":"sent"]
        return dictionary as [String : AnyObject]
    }
}
