//
//  EventsViewModel.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

protocol EventsViewModelDelegate: BaseViewModelDelegate {
    
}

typealias EventsViewModelDelegateType = (UIViewController & EventsViewModelDelegate)

class EventsViewModel {

    private weak var delegate: EventsViewModelDelegateType?
    
    init(delegate: EventsViewModelDelegateType) {
        self.delegate = delegate
    }
}
