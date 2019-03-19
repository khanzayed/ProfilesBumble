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

    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
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

extension UIColor {
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            
            let index   = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex     = String(rgba[index...])
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                
                if 6 == hex.count {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if 8 == hex.count {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                print("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    convenience init(hex: String, alpha:CGFloat) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
}

