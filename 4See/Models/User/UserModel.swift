//
//  UserModel.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import Foundation
struct UserCredentials:Codable {
    var username:String
    var password:String
}
struct UserModel:Codable {
    var token:String?
    var userInfo: UserInfo?
    private enum CodingKeys: String, CodingKey {
        case token
        case userInfo
    }
}

struct UserInfo:Codable {
    
    var id:String?
    var updatedAt:String?
    var createdAt:String?
    var name:String?
    var userRole:String?
    var reportLine:String?
    var idNr:String?
    var password:String?
    var email:String?
    var address:String?
    var department:String?
    var payroll:String?
    var __v:Int?
    var jobTitle:String?
    var vechileNumber:String?
    var companyId:CompanyProfile?
    var auth:String?
    var status:String?
    var deviceToken:String?
    var image:String?
    var phone:String?
    var gender:String?
    var notification:String?
    var geoLocaton:String?
    var alramTime:String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case updatedAt
        case createdAt
        case name
        case userRole
        case reportLine
        case idNr
        case password 
        case email
        case address
        case department
        case payroll
        case __v
        case jobTitle
        case auth
        case status
        case deviceToken
        case image
        case phone
        case vechileNumber
        case companyId
        case gender
        case notification
        case geoLocaton
        case alramTime
    }
    
    var createdDate : Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = createdAt {
            return dateFormatterGet.date(from: date) ?? Date()
        }
        return Date()
    }
    
}
struct CompanyProfile:Codable {
    var _id:String?
    var name: String?
    var image: String?
    var location : loc?

    private enum CodingKeys: String, CodingKey {
        case _id
        case name
        case image
        case location

    }
}
struct loc:Codable {
    var lat:String?
    var lng: String?

    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}

