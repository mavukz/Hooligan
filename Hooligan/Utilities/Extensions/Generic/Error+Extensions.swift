//
//  Error+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

extension Error {

    static func createCustomError(with errorMessage: String, statusCode: Int = 500) -> Error {
        return NSError(domain: "",
                       code: statusCode,
                       userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
}
