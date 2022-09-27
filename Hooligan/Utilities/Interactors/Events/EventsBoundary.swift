//
//  EventsBoundary.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

protocol EventsBoundary {
    
    func retrieveEvents() async throws -> [EventsResponseModel]?
}
