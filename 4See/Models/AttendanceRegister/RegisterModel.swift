//
//  RegisterModel.swift
//  4See
//
//  Created by Gagan Arora on 21/04/21.
//

import Foundation
struct RegisterModel:Codable {
    var _id:idInfo?
    var reason:String?
    var userId:String?
    var message:String?
    var location:locnInfo?
    var updatedAt:String?
    var date:String?
    var type:String?
   
    init(_id: idInfo?,reason: String?,userId: String?,message: String?,location: locnInfo?,updatedAt: String?,date: String?,type: String?){
        self._id = _id
        self.reason = reason
        self.userId = userId
        self.message = message
        self.location = location
        self.updatedAt = updatedAt
        self.date = date
        self.type = type
    }
}

struct idInfo:Codable {
    var date:String?
    var email:String?
    var name:String?
    
    init(date: String?,email: String?,name: String?){
        self.date = date
        self.email = email
        self.name = name
       
       }
}
struct locnInfo:Codable {
    var lat:Double?
    var lng:Double?
    init(lat: Double?,lng: Double?){
        self.lat = lat
        self.lng = lng
       
       }
    
}
