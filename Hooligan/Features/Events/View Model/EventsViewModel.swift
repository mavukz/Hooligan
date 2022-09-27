//
//  EventsViewModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

protocol EventsViewModelDelegate: BaseViewModelDelegate {
    
    func refreshViewContents()
}

typealias EventsViewModelDelegateType = (UIViewController & EventsViewModelDelegate)

class EventsViewModel {

    private weak var delegate: EventsViewModelDelegateType?
    private let eventsInteractor: EventsBoundary
    
    private var eventsResponseModel: [EventsResponseModel]? // can wrap this in a responseProtocol if needed and if response model is likely to change
    
    init(delegate: EventsViewModelDelegateType,
         eventsInteractor: EventsBoundary) {
        self.delegate = delegate
        self.eventsInteractor = eventsInteractor
    }
    
    // Still need to figure out how to return on main thread globally using async await concurrency. This was much easier with completion blocks
    func retrieveRemoteEvents() {
        Task {
            do {
                let events = try await eventsInteractor.retrieveEvents()
                await MainActor.run {
                    self.handleEventsResponse(events)
                }
            } catch(let error as ResponseErrorType) {
                await MainActor.run {
                    switch error {
                    case .unauthorized(let message):
                        self.delegate?.handleUnauthorized(message)
                    case .notFound(let message):
                        self.delegate?.showErrorAlert(message: message)
                    case .generic(let message):
                        self.delegate?.showErrorAlert(message: message)
                    case .noInternet:
                        self.delegate?.handleNoInternetConnection()
                    }
                }
            }
        }
    }
    
    private func handleEventsResponse(_ response: [EventsResponseModel]?) {
        self.eventsResponseModel = response
        self.delegate?.refreshViewContents()
    }
}
