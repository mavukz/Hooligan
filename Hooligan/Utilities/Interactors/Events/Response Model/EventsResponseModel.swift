//
//  EventsResponseModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

struct EventsResponseModel: Codable {
    let id, title: String?
    let imageURL: String?
    let subtitle: String?
    let videoURL: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case imageURL = "imageUrl"
        case subtitle
        case videoURL = "videoUrl"
        case date
    }
}
