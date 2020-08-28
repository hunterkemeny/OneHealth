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
        print(value)
        if value == "" || value == "0.0" {
            valueLabel.text = "not logged"
        } else {
            valueLabel.text = "logged"
        }
    }

}
