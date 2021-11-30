//
//  CountrySelectModel.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit

class CountrySelectModel {
    
    var name = ""
    var countryCode =  ""
    var phoneCode = ""
    
    init(name:String,countryCode:String, phoneCode:String) {
        self.name = name
        self.countryCode = countryCode
        self.phoneCode = phoneCode
    }
}
