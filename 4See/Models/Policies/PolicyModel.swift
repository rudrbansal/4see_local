//
//  PolicyModel.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import Foundation

struct PolicyModel:Codable {
    let data: [policyInfo]?
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct policyInfo:Codable {
    var _id:String?
    var updatedAt:String?
    var createdAt:String?
    var title:String?
    var companyId:String?
    var __v:Int?
    var status:String?
    var document:String?
    var description:String?

    private enum CodingKeys: String, CodingKey {
        case _id
        case updatedAt
        case createdAt
        case title
        case companyId
        case __v
        case status
        case document
        case description
       
    }
    
}
