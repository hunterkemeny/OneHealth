//
//  PersonalTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var personalImage: UIImageView!
    
    
    func setAttributes(category: String, info: Information) {
        
        personalImage.image = info.icon
        collectionLabel.text = category
    }
}
