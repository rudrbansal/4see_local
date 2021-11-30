//
//  MessageModel.swift
//  4See
//
//  Created by Gagan Arora on 19/04/21.
//

import Foundation

struct MessageModel:Codable {
    let messages: [msgInfo]?
    private enum CodingKeys: String, CodingKey {
        case messages
    }
}

struct msgInfo:Codable {
    var _id:String?
    var body:String?
    var senders:senderInfo?
    var createdAt:String?
    var subject:String?
    var updatedAt:String?
    var parentId:String?
    var status:String?
    var recipients:recipientInfo?
    var isDeleted:String?
    
    private enum CodingKeys: String, CodingKey {
        case _id
        case body
        case createdAt
        case senders
        case subject
        case updatedAt
        case status
        case recipients
        case parentId
        case isDeleted
    }
    
}
struct senderInfo:Codable {
    var _id:String?
    var email:String?
    var name:String?
   
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name = "name"
        case email = "email"
    }
}

struct recipientInfo:Codable {
    let _id : String?
    let messageId : String?
    let isRead : String?
    let isFavorite : String?
    let isDeleted : String?

    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case messageId = "messageId"
        case isRead = "isRead"
        case isFavorite = "isFavorite"
        case isDeleted = "isDeleted"

    }
    
   
}
