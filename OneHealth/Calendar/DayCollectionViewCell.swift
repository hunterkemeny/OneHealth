//
//  DayCollectionViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var dayLabel: UILabel!
    
    // MARK: - Method
    
    func setAttributes(day: Int, today: Bool) {
        // If this DayCollectionViewCell does not belong do the month of its TableView row, leave the square empty. Otherwise, fill the CollectionViewCell with the day of the month.
        if today == true {
            dayLabel.textColor = UIColor.white
        }
        if day != 0 {
            dayLabel.text = String(day)
        } else {
            dayLabel.text = ""
        }
    }
}
