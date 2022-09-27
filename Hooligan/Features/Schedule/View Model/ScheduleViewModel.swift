//
//  ScheduleViewModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

protocol ScheduleViewModelDelegate {
    
}

typealias ScheduleViewModelDelegateType = (UIViewController & ScheduleViewModelDelegate)

class ScheduleViewModel {

    private weak var delegate: ScheduleViewModelDelegateType?
    
    init(delegate: ScheduleViewModelDelegateType) {
        self.delegate = delegate
    }
}
