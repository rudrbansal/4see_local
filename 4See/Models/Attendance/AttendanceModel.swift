//
//  AttendanceModel.swift
//  4See
//
//  Created by Gagan Arora on 30/03/21.
//

import Foundation

struct AttendanceModel:Codable {
    
    let _id: String?
    let updatedAt: String?
    let createdAt: String?
    let date: String?
    let userId: String?
    let __v: Int?
    let location: locationInfo?
    let type: String?
    let chekcIntype :String?
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case updatedAt
        case createdAt
        case date
        case userId
        case __v
        case location
        case type
        case chekcIntype

    }
}

struct locationInfo:Codable {
    var lat:Double?
    var lng:Double?

    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
        }
    
}
