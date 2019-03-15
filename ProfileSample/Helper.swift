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


extension UILabel {
    
    func setText(text: String, withLineSpacing lineSpacing: CGFloat, style: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = style
        
        let placeAttr: [NSAttributedString.Key:Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        self.attributedText = NSAttributedString(string: text, attributes: placeAttr)
    }
    
    func setText(attText: NSMutableAttributedString, withLineSpacing lineSpacing: CGFloat, style: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = style
        
        attText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attText.string.count))
        
        self.attributedText = attText
    }
    
}

extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
}

extension String {
    
    func getAttributedString(withLineSpacing lineSpacing: CGFloat, style: NSTextAlignment, font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = style
        
        let placeAttr: [NSAttributedString.Key:Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.font: font]
        
        return NSAttributedString(string: self, attributes: placeAttr)
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
}
