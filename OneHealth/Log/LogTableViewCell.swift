//
//  LogTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    func setAttributes(category: String) {
        categoryLabel.text = category
    }

}
