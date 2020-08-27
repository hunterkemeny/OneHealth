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
    @IBOutlet weak var caloriesConsumedValue: UILabel!
    @IBOutlet weak var fastedValue: UILabel!
    @IBOutlet weak var minutesMeditatedValue: UILabel!
    @IBOutlet weak var caloricSurplusValue: UILabel!
    
    var water: String?
    var calsBurned: String?
    var dayMonthYear: String?
    var calsConsumed: String?
    var hoursFasted: String?
    var minutesMeditated: String?
    var caloricSurplus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayMonthYearLabel.text = dayMonthYear
        caloriesBurnedValue.text = calsBurned
        waterValue.text = water
        caloriesConsumedValue.text = calsConsumed
        fastedValue.text = hoursFasted
        minutesMeditatedValue.text = minutesMeditated
        caloricSurplusValue.text = caloricSurplus
        
    }
    

}
