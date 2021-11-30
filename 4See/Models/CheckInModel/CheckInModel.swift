//
//  CheckInModel.swift
//  4See
//
//  Created by Gagan Arora on 28/04/21.
//

import Foundation

struct CheckInModel:Codable {
    var __v:Int?
    var _id:String?
    var chekcIntype:String?
    var createdAt:String?
    var date:String?
    var type:String?
    var updatedAt:String?
    var userId:String?

    private enum CodingKeys: String, CodingKey {
        case __v
        case _id
        case chekcIntype
        case createdAt
        case date
        case type
        case updatedAt
        case userId
       

    }
    
}
struct locanInfo:Codable {
    var lat:Double?
    var lng:Double?
    init(lat: Double?,lng: Double?){
        self.lat = lat
        self.lng = lng
       
       }
    
}
