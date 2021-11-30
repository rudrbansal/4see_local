//
//  SystemModel.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation

struct SystemModel:Codable {
    let data: [sytemsInfo]?
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct sytemsInfo:Codable {
    var id:String?
    var title:String?
    var serialNumber:String?
    var images:[String]?
    var status:String?
    var userId:String?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case serialNumber
        case images
        case status
        case userId

    }
    
}
