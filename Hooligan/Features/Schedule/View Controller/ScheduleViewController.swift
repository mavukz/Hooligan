//
//  ScheduleViewController.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var scheduleTableView: UITableView!
    
    private lazy var viewModel = ScheduleViewModel(delegate: self, scheduleInteractor: ScheduleInteractor.shared)
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingScreen()
        viewModel.retrieveRemoteSchedules()
        configureUI()
    }
    
    private func configureUI() {
        scheduleTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: .main),
                                 forCellReuseIdentifier: "PlayerTableViewCell")
        // can be set in IB
        scheduleTableView.dataSource = self
        timer = Timer.scheduledTimer(withTimeInterval: 30,
                                     repeats: true) { _ in
            self.viewModel.retrieveRemoteSchedules()
        }
    }
}

// MARK: - ScheduleViewModelDelegate
extension ScheduleViewController: ScheduleViewModelDelegate {
 
    func reloadSchedules() {
        hideLoadingScreen() // hides if visible
        scheduleTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
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
