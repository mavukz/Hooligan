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
    private var playerDataModel: [PlayerDataModel]?
    var selectedIndexPath: IndexPath?
    
    init(delegate: EventsViewModelDelegateType,
         eventsInteractor: EventsBoundary) {
        self.delegate = delegate
        self.eventsInteractor = eventsInteractor
    }
    
    // MARK: - Getters
    
    var selectedPlayerVideoURL: URL? {
        guard let rowIndex = selectedIndexPath?.row,
              let urlString = eventsResponseModel?[safe: rowIndex]?.videoURL
        else { return nil }
        return URL(string: urlString)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        // ignore section since we working with one section for now
        return eventsResponseModel?.count ?? 0
    }
    
    func playerDataModel(at indexPath: IndexPath) -> PlayerDataModel? {
        return playerDataModel?[safe: indexPath.row]
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
        self.eventsResponseModel = sortByDate(response)
        self.playerDataModel = response?.map {
            PlayerDataModel(title: $0.title,
                            subtitle: $0.subtitle,
                            date: self.formatDate($0.date),
                            imageURL: $0.imageURL)
        }
        self.delegate?.refreshViewContents()
    }
    
    private func formatDate(_ dateString: String?) -> String? {
        guard let safeDateString = dateString,
              let date = String.date(safeDateString, format: .longDateFormat)
        else { return nil }
        if Calendar.current.isDateInToday(date) {
            let time = date.string(format: .timeFormat)
            return "\(NSLocalizedString("TODAY", comment: "")), \(time)"
        } else if Calendar.current.isDateInYesterday(date) {
            let time = date.string(format: .timeFormat)
            return "\(NSLocalizedString("YESTERDAY", comment: "")), \(time)"
        } else {
            // Assuming date is now and past and not future dates.
            return date.string(format: .simpleDotDateFormat)
        }
    }
    
    typealias IdDateType = (id: String, date: Date)
    // FIXME: - needs improvement where if dateString fails to convert or if lets expression is false
    // rushing happy case for now
    private func sortByDate(_ response: [EventsResponseModel]?) -> [EventsResponseModel]? {
        var returnResponse: [EventsResponseModel] = []
        var referenceList: [IdDateType] = []
        response?.forEach {
            if let dateString = $0.date,
               let date = String.date(dateString, format: .longDateFormat),
               let id = $0.id {
                referenceList.append((id, date))
            }
        }
        let sortedRefList = referenceList.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        sortedRefList.forEach {
            let id = $0.id
            if let responseItem = response?.first(where: { $0.id == id }) {
                returnResponse.append(responseItem)
            }
        }
        return returnResponse
    }
}
