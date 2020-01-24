//
//  PersonalTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    func setAttributes(category: String) {
        
        collectionLabel.text = category
    }
}
