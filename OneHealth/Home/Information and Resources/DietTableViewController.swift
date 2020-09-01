//
//  DietTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class DietTableViewController: UITableViewController {
    
    var BMR:Double = 0.0
    var calorieDeltaPerDay:Double = 0.0
    var db: Firestore!
    var docRef: DocumentReference!
    let formatter  = DateFormatter()
    
    
    @IBOutlet weak var GainLossLabel: UILabel!
    @IBOutlet weak var eatCalLabel: UILabel!
    @IBOutlet weak var burnCalLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    
    func getData() {
        var userID = Auth.auth().currentUser?.uid
        docRef = Firestore.firestore().document("surveyInfo/\(userID! ?? "")")
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            
            // CANT ALL THIS BE RETRIEVED FROM COREDATA?
            
            //AGE
            let age = myData?["age"] as? String ?? ""
            PersonInfo.setAge(age: Int(age) ?? 0)
            
            //WEIGHT STATUS
            let weight_status = myData?["goal-type"] as? String ?? ""
            if weight_status == "lose" {
                PersonInfo.setGainLoseMaintain(gainLoseMaintain: -1)
            } else {
                PersonInfo.setGainLoseMaintain(gainLoseMaintain: 1)
            }
            
            //HEIGHT
            let height = myData?["height"] as? String ?? ""
            PersonInfo.setHeight(height: Int(height) ?? 0)
            
            //SEX
            let sex = myData?["sex"] as? String ?? ""
            if sex == "Male" {
                PersonInfo.setSex(sex: 1)
            } else {
                PersonInfo.setSex(sex: 0)
            }
                
            //WEIGHT
            let weight = myData?["weight"] as? String ?? ""
            
            PersonInfo.setWeight(weight: Int(weight) ?? 0)
                
            //WEIGHT CHANGE GOAL
            let weightChangeGoal = myData?["weight-change-goal"] as? String ?? ""
            var desiredWeight = 0
            if PersonInfo.getGainLoseMaintain() == -1 {
                desiredWeight = PersonInfo.getWeight() - (Int(weightChangeGoal) ?? 0)
            } else {
                desiredWeight = PersonInfo.getWeight() + (Int(weightChangeGoal) ?? 0)
            }
            PersonInfo.setDesiredWeight(desiredWeight: desiredWeight)
            
            //TIME TO COMPLETE GOAL
            var doubleTime = myData?["time-to-complete"] as? Double
            var time = Int(doubleTime!)
            PersonInfo.setDaysToCompleteGoal(daysToCompleteGoal: time)
            
            self.calculateMaintenence()
            self.calculateCalorieDeltaPerDay()
            self.LoseOrGain(days: time)
            self.determineExercise()
            self.calculateIntake()
            self.calculateTotalBurn()
            self.setWaterLabel()
        }
    }
    
    func LoseOrGain(days: Int?) {
        if PersonInfo.gainLoseMaintain == -1 {
            GainLossLabel.text = "You need be at a caloric deficit of about \(setCalLabel()) calories per week in order to meet your goal in \(days!/7) weeks"
        }
        
        if PersonInfo.gainLoseMaintain == 1 {
            GainLossLabel.text = "You need be at a caloric surplus of about \(setCalLabel()) calories per week in order to meet your goal in \(days!/7) weeks"
        }
        
        if PersonInfo.gainLoseMaintain == 0 {
            GainLossLabel.text = "You do not need to be at a caloric deficit or surplus."
        }
    }
    
    func setCalLabel() -> Int{
        if (PersonInfo.gainLoseMaintain != 0) {
            print(calorieDeltaPerDay)
            return Int(calorieDeltaPerDay) * 7
        } else {
            return 0
        }
    }
    
    func calculateMaintenence() {
        
        BMR = PersonInfo.calculateBMR()
        let isMan:Bool = (PersonInfo.getSex()==1)
        var maintenence = 0.0
        
        if isMan {
            maintenence = BMR + 700
        } else {
            maintenence = BMR + 450
        }
        PersonInfo.setMaintenence(maintenence: maintenence)
    }
    
    var constantExercise: Double = 0.0
    var constantIntake: Double = 0.0
    
    
    func getDayOfWeek(_ today:String) -> Int? {
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func determineExercise() {
        formatter.dateFormat = "yyyy-MM-dd"
        var day = getDayOfWeek(formatter.string(from: Date()))
        if day == 1 || day == 7 {
            constantExercise = 100
        } else {
            constantExercise = 500
        }
    }
    
    // Change intake to account for days exercising and not exercising
    func calculateIntake() {
        formatter.dateFormat = "yyyy-MM-dd"
        var day = getDayOfWeek(formatter.string(from: Date()))
        
        var intake:Double = 0.0
        if PersonInfo.getGainLoseMaintain() == 0 {
            intake = PersonInfo.getMaintenence() + (constantExercise)
        }
        if PersonInfo.getGainLoseMaintain() == 1 {
            
            intake = PersonInfo.getMaintenence() + (constantExercise) + (calorieDeltaPerDay)
            print(PersonInfo.getMaintenence())
            print(constantExercise)
            print(calorieDeltaPerDay)
        }
        if PersonInfo.getGainLoseMaintain() == -1 {
            if day == 1 || day == 7 {
                calorieDeltaPerDay += 400
            } else {
                calorieDeltaPerDay -= 175
            }
            intake = PersonInfo.getMaintenence() + (constantExercise) - (calorieDeltaPerDay)
            
        }
        eatCalLabel.text = "And consume \(Int(intake)) calories today."
    }
    
    func calculateTotalBurn(){
        var exercise:Double = 0.0
        if PersonInfo.getGainLoseMaintain() == 0 {
            exercise = PersonInfo.getMaintenence() + constantExercise
        }
        if PersonInfo.getGainLoseMaintain() == 1 {
            exercise = PersonInfo.getMaintenence() + constantExercise
        }
        if PersonInfo.getGainLoseMaintain() == -1 {
            exercise = PersonInfo.getMaintenence() + constantExercise + (calorieDeltaPerDay)
        }
               
        burnCalLabel.text = "Therefore, you need to burn \(Int(exercise)) total calories per day."
    }
    
    func calculateCalorieDeltaPerDay() {
        var calorieDelta = 0
        if PersonInfo.getGainLoseMaintain() == 1 {
            calorieDelta = abs(3555 * (PersonInfo.getDesiredWeight() - PersonInfo.getWeight()))
        }
        if PersonInfo.getGainLoseMaintain() == -1 {
            calorieDelta = abs(3555 * (PersonInfo.getWeight()-PersonInfo.getDesiredWeight()))
        }
        calorieDeltaPerDay = Double(calorieDelta)/Double(PersonInfo.getDaystoCompleteGoal())
        PersonInfo.setDailyCalorieDelta(dailyCalorieDelta: calorieDeltaPerDay)
    }
    
    func setWaterLabel() {
        waterLabel.text = "Aim for about 65 - 85 oz of water."
    }
}
