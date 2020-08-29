//
//  WorkoutTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    @IBOutlet weak var todaysWorkoutLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    
    var workout: String? = ""
    
    let formatter  = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineExercise()
        
    }
    
    func determineExercise() {
        formatter.dateFormat = "yyyy-MM-dd"
        var day = getDayOfWeek(formatter.string(from: Date()))
        if day == 1 || day == 7 {
            todaysWorkoutLabel.text = "Rest! Or, if you'd like, go on a walk or jog."
        } else if day == 2 || day == 4 {
            todaysWorkoutLabel.text = "Cardio today!"
            workoutLabel.text = "Should be at the intensity of at least a 30 minute run. Then, perform the following ab exercises: INSERT HERE"
        } else if day == 1 {
            todaysWorkoutLabel.text = "Today's Workout: Legs"
            workoutLabel.text = "get legs workout"
        } else if day == 3 {
            todaysWorkoutLabel.text = "Today's Workout: Chest/Shoulders/Triceps"
            workoutLabel.text = "get day 1 workout"
        } else {
            todaysWorkoutLabel.text = "Today's Workout: Biceps/Back"
            workoutLabel.text = "get day 2 workout"
        }
    }
    
    
    func getDayOfWeek(_ today:String) -> Int? {
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    

    

}

