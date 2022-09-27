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
    
    init(delegate: ScheduleViewModelDelegateType,
         scheduleInteractor: ScheduleBoundary) {
        self.delegate = delegate
        self.scheduleInteractor = scheduleInteractor
    }
    
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
    
    private func handleSchedulesResponse(_ response: [ScheduleResponseModel]?) {
        self.schedulesResponseModels = response
    }
}
