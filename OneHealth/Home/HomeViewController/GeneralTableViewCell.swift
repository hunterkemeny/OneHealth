//
//  GeneralTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var generalImageView: UIImageView!
    
    // MARK: - Method
    
    func setAttributes(category: String, info: Information) {
        collectionLabel.text = category
        generalImageView.image = info.icon
        
        // Stylize generalImageView.
        generalImageView.layer.borderWidth = 0
        generalImageView.layer.masksToBounds = false
        generalImageView.layer.cornerRadius = 25
        generalImageView.clipsToBounds = true
    }
    
}
