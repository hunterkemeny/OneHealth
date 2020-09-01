//
//  PersonalTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var personalImage: UIImageView!
    
    // MARK: - Method
    
    func setAttributes(category: String, info: Information) {
        personalImage.image = info.icon
        collectionLabel.text = category
        
        // Stylize personalImage.
        personalImage.layer.borderWidth = 0
        personalImage.layer.masksToBounds = false
        personalImage.layer.cornerRadius = 25
        personalImage.clipsToBounds = true
    }
}
