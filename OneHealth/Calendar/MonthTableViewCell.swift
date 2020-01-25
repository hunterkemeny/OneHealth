//
//  MonthTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class MonthTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        daysCollectionView.delegate = dataSourceDelegate
        daysCollectionView.dataSource = dataSourceDelegate
        daysCollectionView.tag = row
        daysCollectionView.reloadData()
    }
    
    func setAttributes(month: String) {
        monthLabel.text = month
    }

}
