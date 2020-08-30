//
//  InfoViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var dayMonthYearLabel: UILabel!
    @IBOutlet weak var caloriesBurnedValue: UILabel!
    @IBOutlet weak var waterValue: UILabel!
    @IBOutlet weak var caloriesConsumedValue: UILabel!
    @IBOutlet weak var fastedValue: UILabel!
    @IBOutlet weak var minutesMeditatedValue: UILabel!
    @IBOutlet weak var caloricSurplusValue: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    
    // MARK: - Properties
    
    var water: String?
    var calsBurned: String?
    var dayMonthYear: String?
    var calsConsumed: String?
    var hoursFasted: String?
    var minutesMeditated: String?
    var caloricSurplus: String?
    var weight: String?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fill labels with property information based on the date chosen on CalendarViewController.
        dayMonthYearLabel.text = dayMonthYear
        caloriesBurnedValue.text = calsBurned
        waterValue.text = water
        caloriesConsumedValue.text = calsConsumed
        fastedValue.text = hoursFasted
        minutesMeditatedValue.text = minutesMeditated
        caloricSurplusValue.text = caloricSurplus
        weightValue.text = weight
        
    }
}
