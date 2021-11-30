//
//  4SeeColors.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SwifterSwift

class BaseColors {

    static var appHeaderColor : UIColor {
        return Color(hexString: "#090742")!
    }
    
    static var themeColor : UIColor {
        return Color(hexString: "#090742")!
    }
    
    static var redColor : UIColor {
        return Color(hexString: "#F10005")!
    }
    
    static var appLightColor : UIColor {
        return Color(hexString: "#F2EEEC")!
    }
    static var whiteColor : UIColor {
        return Color(hexString: "#FFFFFF")!
    }
    static var borderThemeColor: UIColor {
        return (UIColor.init(named: "BorderTheme") ?? BaseColors.themeColor) as UIColor
    }
}
