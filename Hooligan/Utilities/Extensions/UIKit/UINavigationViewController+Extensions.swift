//
//  UINavigationViewController+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        get {
            return viewControllers.first
        } set {
            guard let safeRootController = newValue else { return }
            viewControllers[0] = safeRootController
        }
    }
}
