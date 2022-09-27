//
//  ScheduleBoundary.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

protocol ScheduleBoundary {
    
    func retrieveSchedules() async throws -> [ScheduleResponseModel]?
}
