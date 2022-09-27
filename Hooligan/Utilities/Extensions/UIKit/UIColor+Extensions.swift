//
//  UIColor+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

extension UIColor {
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let r, g, b: CGFloat
        
        var hexColor = hex
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        }
        if hexColor.count == 8 || hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 32) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 16) / 255
                b = CGFloat(hexNumber & 0x0000FF >> 8) / 255
                self.init(red: r, green: g, blue: b, alpha: alpha)
            }
        }
        return nil
    }
}

// Color palette
extension UIColor {
    
//    static let customColor1 = UIColor(red: 100 / 255, green: 100 / 255, blue: 240 / 255, alpha: 1)
}
