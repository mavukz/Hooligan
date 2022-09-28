//
//  Date+Extensions.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

enum HoolieDateFormatter: String {
    case longZDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case longDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case simpleDateAndTimeFormat = "yyyy-MM-dd HH:mm"
    case simpleDotDateFormat = "dd.MM.yyyy"
    case simpleDateFormat = "yyyy-MM-dd"
    case timeFormat = "hh:mm a"
    case month = "MM"
    case day = "dd"
}

extension Date {
   
    func string(format: HoolieDateFormatter,
                dateStyle: DateFormatter.Style? = nil) -> String {
        let formatter = DateFormatter()
        if let style = dateStyle {
            formatter.dateStyle = style
        }
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
