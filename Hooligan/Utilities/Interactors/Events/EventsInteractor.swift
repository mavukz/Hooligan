//
//  EventsInteractor.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation

class EventsInteractor: EventsBoundary {
    
    static let shared = EventsInteractor()
    private init() { }
    
    func retrieveEvents() async throws -> [EventsResponseModel]? {
        let url = "/getEvents"
        let manager = WebServicesManager<[EventsResponseModel]>()
        let response = await manager.GET(url: url)
        if response.errorStatus == nil {
            return response.result
        } else {
            throw response.errorStatus!
        }
    }
}
