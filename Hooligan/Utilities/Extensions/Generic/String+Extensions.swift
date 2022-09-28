//
//  String+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/28.
//

import Foundation

extension String {
    
    static func isNilOrWhitespace(_ text: String?) -> Bool {
        guard let noNilText = text else { return true }
        return noNilText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    static func encodedURL(from string: String?) -> URL? {
        guard !String.isNilOrWhitespace(string),
              let safeString = string?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return nil }
        return URL(string: safeString)
    }
}

// MARK: - Date Conversion
extension String {
    
    var dateFormatter: DateFormatter {
        return DateFormatter()
    }
    
    static func date(_ dateString: String, format: HoolieDateFormatter) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateString)
    }
}
