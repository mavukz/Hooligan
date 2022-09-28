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
    
    private(set) var dataModel: PlayerDataModel?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyling()
    }
    
    // MARK: - Configuration
    func configure(with dataModel: PlayerDataModel) {
        self.dataModel = dataModel
        playerImageView.fromURLString(dataModel.imageURL)
        titleLabel.text = dataModel.title
        subtitleLabel.text = dataModel.subtitle
        dateLabel.text = dataModel.date
    }
    
    // MARK: - Private
    private func applyStyling() {
        // set fonts and colors
    }
}
