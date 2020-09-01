//
//  HeaderTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: - Method
    
    func setAttributes(header: String) {
        headerLabel.text = header
    }
}
