//
//  GeneralTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var generalImageView: UIImageView!
    
    func setAttributes(category: String, info: Information) {
        
        collectionLabel.text = category
        generalImageView.image = info.icon
    }
    
}
