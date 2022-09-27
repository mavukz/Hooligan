//
//  ScheduleResponseModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

struct ScheduleResponseModel: Codable {
    let id, title: String?
    let imageURL: String?
    let subtitle, date: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "imageUrl"
        case subtitle, date
    }
}
