//
//  Colors.swift
//  ProfileSample
//
//  Created by admin on 13/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
 
    static let App_Light_Grey = "AppLightGrey"
    static let App_Black = "AppBlack"
    static let App_Grey = "AppGrey"
    static let Primary_Blue = "PrimaryBlue"
    
}

extension UIFont {

    internal class func ProximaNovaLight(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Light", size: fontSize)!
    }
    
    internal class func ProximaNovaSemiBold(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Semibold", size: fontSize)!
    }
    
    internal class func ProximaNovaBold(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Bold", size: fontSize)!
    }
    
    internal class func ProximaNovaExtrabold(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Regular", size: fontSize)!
    }
    
    internal class func ProximaNovaRegular(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Regular", size: fontSize)!
    }
    
    internal class func ProximaNovaMedium(fontSize: CGFloat) -> UIFont {
        return UIFont.init(name: "ProximaNova-Medium", size: fontSize)!
    }
    
}
