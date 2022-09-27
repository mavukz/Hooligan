//
//  EventsViewController.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

class EventsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    private lazy var viewModel = EventsViewModel(delegate: self,
                                                 eventsInteractor: EventsInteractor.shared)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate show loading
        viewModel.retrieveRemoteEvents()
    }
}

// MARK: - EventsViewModelDelegate
extension EventsViewController: EventsViewModelDelegate {
    
    func refreshViewContents() {
        // hide loading
        // reload data
    }
}
