//
//  EventsViewController.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit
import AVKit

class EventsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var eventsTableView: UITableView!
    
    private lazy var viewModel = EventsViewModel(delegate: self,
                                                 eventsInteractor: EventsInteractor.shared)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingScreen()
        viewModel.retrieveRemoteEvents()
        configureUI()
    }
    
    private func configureUI() {
        eventsTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: .main),
                                 forCellReuseIdentifier: "PlayerTableViewCell")
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    private func createPlayerController() -> AVPlayerViewController? {
        guard let url = viewModel.selectedPlayerVideoURL
        else { return nil }
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: url)
        controller.player = player
        return controller
    }
}

// MARK: - EventsViewModelDelegate
extension EventsViewController: EventsViewModelDelegate {
    
    func refreshViewContents() {
        self.hideLoadingScreen()
        eventsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell") as? PlayerTableViewCell,
              let dataModel = viewModel.playerDataModel(at: indexPath)
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: dataModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath = indexPath
        if let playerController = createPlayerController() {
            self.present(playerController, animated: true)
        }
    }
}
