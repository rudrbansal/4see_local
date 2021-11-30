//
//  NotesModel.swift
//  4See
//
//  Created by Gagan Arora on 13/04/21.
//

import Foundation

struct NotesModel:Codable {
    let data: [noteInfo]?
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct noteInfo:Codable {
    var _id:String?
    var updatedAt:String?
    var createdAt:String?
    var note:String?
    var name:String?
    var userId:String?

    private enum CodingKeys: String, CodingKey {
        case _id
        case updatedAt
        case createdAt
        case note
        case userId
        case name

       
    }
    
}
