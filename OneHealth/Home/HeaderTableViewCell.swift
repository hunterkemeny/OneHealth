//
//  HeaderTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerLabel: UILabel!
    
    func setAttributes(header: String) {
        headerLabel.text = header
    }
    
}
