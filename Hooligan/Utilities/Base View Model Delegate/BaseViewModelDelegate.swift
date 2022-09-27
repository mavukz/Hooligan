//
//  BaseViewModelDelegate.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation
import UIKit

protocol BaseViewModelDelegate: NSObjectProtocol {
    
    func showErrorAlert(withTitle title: String?,
                        message: String?,
                        onDismissHandler completion: EmptyCompletionType?)
    
    func showErrorAlert(message: String?,
                        onDismissHandler completion: EmptyCompletionType?)
    
    func showErrorAlert(message: String?)
    
    func showLoadingScreen(with message: String?, animated: Bool)
    
    func hideLoadingScreen(animated: Bool)
    
    func handleUnauthorized(_ message: String?)
    
    func handleNoInternetConnection()
    
}

extension BaseViewModelDelegate where Self: UIViewController {
    
    func showErrorAlert(withTitle title: String?,
                        message: String?,
                        onDismissHandler completion: EmptyCompletionType?) {
        self.presentErrorAlert(withTitle: title,
                               message: message,
                               onDismissHandler: completion)
    }
    
    func showErrorAlert(message: String?,
                        onDismissHandler completion: EmptyCompletionType?) {
        self.presentErrorAlert(withTitle: nil,
                               message: message,
                               onDismissHandler: completion)
    }
    
    func showErrorAlert(message: String?) {
        self.presentErrorAlert(withTitle: nil,
                          message: message,
                          onDismissHandler: nil)
    }
    
    func showLoadingScreen(with message: String? = nil, animated: Bool = false) {
        // To be implemented
    }
    
    func hideLoadingScreen(animated: Bool = true) {
       // To be implemented
    }
    
    func handleUnauthorized(_ message: String?) {
//        dismiss and clear persisted or cached data then navigate to login or landing screen
    }
    
    func handleNoInternetConnection() {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("NO_INTERNET_CONNECTION", comment: ""),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: .default))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Private
    private func presentErrorAlert(withTitle title: String?,
                                   message: String?,
                                   onDismissHandler completion: EmptyCompletionType?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                        style: .default) { _ in
            completion?()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
}
