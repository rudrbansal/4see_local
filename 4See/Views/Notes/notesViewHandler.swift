//
//  notesViewHandler.swift
//  4See
//
//  Created by Gagan Arora on 13/04/21.
//

import Foundation

class notesViewHandler {

    static let `default` = notesViewHandler()
    var note = ""
    var name = ""
    var id = ""

}

extension notesViewHandler {
    
    /// Create JSON Object
    func addNoteObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["note": note,
                                         "name":name]
        return dictionary as [String : AnyObject]
    }
    /// Create JSON Object
    func editNoteObject() -> [String: AnyObject] {
        let dictionary: [String: Any] = ["id": id,
                                          "note": note,
                                          "name":name]
        return dictionary as [String : AnyObject]
    }
}
