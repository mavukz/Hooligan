//
//  PlayerTableViewCell.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private var playerImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyling()
    }
    
    // MARK: - Configuration
    func configure(with dataModel: String) {
        // get data model object and set outlet values
    }
    
    // MARK: - Private
    private func applyStyling() {
        // set fonts and colors
    }
}
