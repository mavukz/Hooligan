//
//  UIApplication+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

extension UIApplication {
    
    static var currentRootViewController: UIViewController? {
        get {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
        set {
            UIApplication.shared.delegate?.window??.rootViewController = newValue
        }
    }
}
