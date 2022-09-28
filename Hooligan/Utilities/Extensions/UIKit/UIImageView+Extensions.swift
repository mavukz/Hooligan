//
//  UIImageView+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/28.
//

import AlamofireImage
import UIKit

extension UIImageView {
    
    enum ImageViewErrorTypes: String {
        case incorrectURL = "Incorrect Image URL Provided"
        case alamofireFailure = "Alamorefire failure" // In future we can listen for specific alamorefire errors but for now not needed
    }
    
    typealias ImageViewErrorCompletionType = (ImageViewErrorTypes) -> Void
    
    func fromURLString(_ url: String?,
                       defaultImage: UIImage? = nil,
                       onFailure: ImageViewErrorCompletionType? = nil) {
        
        if let url = String.encodedURL(from: url) {
            self.af.setImage(withURL: url,
                             completion: { imageData in
                if let _ = imageData.error {
                    onFailure?(.alamofireFailure)
                    return
                }
            })
        } else {
            if let defaultImage = defaultImage {
                self.image = defaultImage
            }
            onFailure?(.incorrectURL)
        }
    }
}
