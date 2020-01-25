//
//  DayCollectionViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    
    
    func setAttributes(day: Int) {
        if day != 0 {
            dayLabel.text = String(day)
        } else {
            dayLabel.text = ""
        }
    }
}
