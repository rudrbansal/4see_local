//
//  AnnouncementModel.swift
//  4See
//
//  Created by Gagan Arora on 24/03/21.
//

import Foundation

struct AnnouncementModel:Codable {
    var data: [infoList]
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct infoList:Codable {
    var _id:String?
    var title:String?
    var description:String?
    var image:String?
    var createdAt : String?
    private enum CodingKeys: String, CodingKey {
        case _id
        case title
        case description
        case image
        case createdAt

    }
    
}

