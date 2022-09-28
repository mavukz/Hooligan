//
//  ScheduleViewModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

protocol ScheduleViewModelDelegate: BaseViewModelDelegate {
    
    func reloadSchedules()
}

typealias ScheduleViewModelDelegateType = (UIViewController & ScheduleViewModelDelegate)

class ScheduleViewModel {

    private weak var delegate: ScheduleViewModelDelegateType?
    private let scheduleInteractor: ScheduleBoundary
    
    private var schedulesResponseModels: [ScheduleResponseModel]?
    private var playerDataModel: [PlayerDataModel]?
    
    // MARK: - Init
    init(delegate: ScheduleViewModelDelegateType,
         scheduleInteractor: ScheduleBoundary) {
        self.delegate = delegate
        self.scheduleInteractor = scheduleInteractor
    }
    
    // MARK: - Getters
    func numberOfRows(inSection section: Int) -> Int {
        // ignore section since we working with one section for now
        return schedulesResponseModels?.count ?? 0
    }
    
    func playerDataModel(at indexPath: IndexPath) -> PlayerDataModel? {
        return playerDataModel?[safe: indexPath.row]
    }
    
    // MARK: - Remote
    func retrieveRemoteSchedules() {
        Task {
            do {
                let response = try await scheduleInteractor.retrieveSchedules()
                await MainActor.run {
                    self.handleSchedulesResponse(response)
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
    
    // MARK: - Sucess response handling
    private func handleSchedulesResponse(_ response: [ScheduleResponseModel]?) {
        self.schedulesResponseModels = sortByDate(response)
        self.playerDataModel = response?.map {
            PlayerDataModel(title: $0.title,
                            subtitle: $0.subtitle,
                            date: self.formatDate($0.date),
                            imageURL: $0.imageURL)
        }
        self.delegate?.reloadSchedules()
    }
    
    // Can be abstracted (maybe base view model for these two)
    private func formatDate(_ dateString: String?) -> String? {
        guard let safeDateString = dateString,
              let date = String.date(safeDateString, format: .longDateFormat)
        else { return nil }
        if Calendar.current.isDateInToday(date) {
            let time = date.string(format: .timeFormat)
            return "\(NSLocalizedString("TODAY", comment: "")), \(time)"
        } else if Calendar.current.isDateInTomorrow(date) {
            let time = date.string(format: .timeFormat)
            return "\(NSLocalizedString("TOMORROW", comment: "")), \(time)"
        } else {
            return date.string(format: .simpleDotDateFormat)
        }
    }
    
    // Can be abstracted (maybe base view model for these two)
    typealias IdDateType = (id: String, date: Date)
    // FIXME: - needs improvement where if dateString fails to convert or if lets expression is false
    // rushing happy case for now
    private func sortByDate(_ response: [ScheduleResponseModel]?) -> [ScheduleResponseModel]? {
        var returnResponse: [ScheduleResponseModel] = []
        var referenceList: [IdDateType] = []
        response?.forEach {
            if let dateString = $0.date,
               let date = String.date(dateString, format: .longDateFormat),
               let id = $0.id {
                referenceList.append((id, date))
            }
        }
        let sortedRefList = referenceList.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        sortedRefList.forEach {
            let id = $0.id
            if let responseItem = response?.first(where: { $0.id == id }) {
                returnResponse.append(responseItem)
            }
        }
        return returnResponse
    }
}
