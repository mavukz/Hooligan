//
//  ScheduleInteractor.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

class ScheduleInteractor: ScheduleBoundary {
 
    static let shared = ScheduleInteractor()
    private init() { }
    
    func retrieveSchedules() async throws -> [ScheduleResponseModel]? {
        let url = "/getSchedule"
        let manager = WebServicesManager<[ScheduleResponseModel]>()
        let response = await manager.GET(url: url)
        if response.errorStatus == nil {
            return response.result
        } else {
            throw response.errorStatus!
        }
    }
}
