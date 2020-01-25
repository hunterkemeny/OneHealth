//
//  LogTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setAttributes(category: String, value: String) {
        categoryLabel.text = category
        if value != "" {
            valueLabel.text = "logged"
        } else {
            valueLabel.text = "not logged"
        }
        
    }

}
