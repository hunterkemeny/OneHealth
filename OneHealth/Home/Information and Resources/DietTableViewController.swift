//
//  DietTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import UIKit
import CoreData

class DietTableViewController: UITableViewController {
    
    var age: String? = ""
    var height: String? = ""
    var gainOrLose: String?
    var sex: Int?
    var weight: Double?
    var weightChangeGoal: String?
    var weeksToComplete: Int?
    var daysToComplete: Int?
    var desiredWeight: Double?
    
    var BMR: Double = 0.0
    var calorieDeltaPerDay: Double = 0.0
    var caloriesToBurnFromExerciseToday: Double? = 0.0
    var caloriesToIntakeToday: Double = 0.0
    
    
    @IBOutlet weak var GainLossLabel: UILabel!
    @IBOutlet weak var eatCalLabel: UILabel!
    @IBOutlet weak var burnCalLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGainLossLabel()
        setBurnCalorieLabel()
        setCalorieIntakeLabel()
        setWaterLabel()
    }
    
    func setGainLossLabel() {
        if gainOrLose == "lose" {
            GainLossLabel.text = "You need be at a caloric deficit of about \(setCalLabel()) calories per week in order to meet your goal in \(PersonInfo.getWeeksToComplete()) weeks"
        } else if gainOrLose == "gain" {
            GainLossLabel.text = "You need be at a caloric surplus of about \(setCalLabel()) calories per week in order to meet your goal in \(PersonInfo.getWeeksToComplete()) weeks"
        } else {
            GainLossLabel.text = "You do not need to be at a caloric deficit or surplus."
        }
    }
    
    func setCalLabel() -> Int {
        if PersonInfo.getGainLoseMaintain() != "maintain" {
            return Int(PersonInfo.calculateCalorieDeltaPerDay()) * 7
        } else {
            return 0
        }
    }
    
    func setBurnCalorieLabel() {
        burnCalLabel.text = "Therefore, you need to burn \(Int(PersonInfo.getTotalCaloriesToBurnToday())) total calories today."
    }
    
    // Change intake to account for days exercising and not exercising
    func setCalorieIntakeLabel() {
        
        eatCalLabel.text = "And consume \(PersonInfo.getTodaysCalorieIntake()) calories today."
    }
    
    func setWaterLabel() {
        waterLabel.text = "Aim for about 65 - 85 oz of water."
    }
}
