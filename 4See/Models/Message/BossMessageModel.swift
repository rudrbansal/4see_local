//
//  BossMessageModel.swift
//  4See
//
//  Created by Gagan Arora on 19/04/21.
//

import Foundation

struct BossMessageModel:Codable {
    let data: [bossMsgInfo]?
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct bossMsgInfo:Codable {
    var _id:String?
    var name:String?
    var email:String?
 
    private enum CodingKeys: String, CodingKey {
        case _id
        case name
        case email
    }
    
}
