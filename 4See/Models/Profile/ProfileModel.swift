//
//  ProfileModel.swift
//  4See
//
//  Created by Gagan Arora on 26/03/21.
//

import Foundation

struct ProfileModel:Codable {
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
    var auth:String?
    var status:String?
    var deviceToken:String?
    var image:String?
    var phone:String?
    
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
    }
    
}

