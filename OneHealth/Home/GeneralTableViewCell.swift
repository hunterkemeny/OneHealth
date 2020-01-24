//
//  GeneralTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionLabel: UILabel!
    
    func setAttributes(category: String) {
        
        collectionLabel.text = category
    }
    
}
