//
//  LeaveModel.swift
//  4See
//
//  Created by Gagan Arora on 01/04/21.
//

import Foundation


struct LeaveModel:Codable {
    let data: [leaveInfo]?
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct leaveInfo:Codable {
    var _id:String?
    var updatedAt:String?
    var createdAt:String?
    var reason:String?
    var message:String?
    var duration:String?
    var date:String?
    var userId:String?
    var __v:Int?
    var status:String?
    var document:[String]?
    var covidNotificaton:String?
    var isCovid:String?

    private enum CodingKeys: String, CodingKey {
        case _id
        case updatedAt
        case createdAt
        case reason
        case message
        case duration
        case date
        case userId
        case __v
        case status
        case document
        case covidNotificaton
        case isCovid

    }
    
}
