//
//  InfoViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var dayMonthYearLabel: UILabel!
    @IBOutlet weak var caloriesBurnedValue: UILabel!
    @IBOutlet weak var waterValue: UILabel!
    
    var water: String?
    var calsBurned: String?
    var dayMonthYear: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayMonthYearLabel.text = dayMonthYear
        caloriesBurnedValue.text = calsBurned
        waterValue.text = water

    }
    

}
