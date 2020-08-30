//
//  LogTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var loggedLabel: UILabel!
    
    func setAttributes(category: String, logValue: String) {
        categoryLabel.text = category
        
        if logValue == "" || logValue == "0.0" {
            loggedLabel.text = "not logged"
        } else {
            loggedLabel.text = "logged"
        }
    }

}
