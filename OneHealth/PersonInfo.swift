//
//  PersonInfo.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import Foundation
// Need to get rid of personinfo? Or add to onboarding process?
class PersonInfo {
    static var age: String = ""
    static var height: String = ""
    static var gainLoseMaintain: String = ""
    static var sex: Int = 0
    static var weight: Double = 0.0
    static var weightChangeGoal: String = ""
    static var weeksToComplete: Int = 0
    static var daysToComplete: Int = 0
    static var todaysCaloriesConsumed: Double = 0.0
    static var caloriesToBurnFromExerciseToday: Double = 0.0
    static var caloriesToIntakeToday: Double = 0.0
    
    static func makePerson(weight: Double, height: String, sex: Int, age: String, gainLoseMaintain: String, weightChangeGoal: String, weeksToComplete: Int, daysToComplete: Int, todaysCaloriesConsumed: Double) {
        
        self.weight = weight
        self.height = height
        self.sex = sex
        self.age = age
        self.daysToComplete = daysToComplete
        self.gainLoseMaintain = gainLoseMaintain
        self.weightChangeGoal = weightChangeGoal
        self.weeksToComplete = weeksToComplete
        self.todaysCaloriesConsumed = todaysCaloriesConsumed
    }
    
    static func setWeight(weight: Double) {
        self.weight = weight
    }
    
    static func getWeight() -> Double {
        return self.weight
    }
    
    static func setHeight(height: String) {
        self.height = height
    }
    
    static func getHeight() -> String {
        return self.height
    }
    
    static func setSex(sex: Int) {
        self.sex = sex
    }
    
    static func getSex() -> Int {
        return sex
    }
    
    static func setAge(age: String) {
        self.age = age
    }
    
    static func getAge() -> String {
        return age
    }
    
    static func setGainLoseMaintain(gainLoseMaintain: String) {
        self.gainLoseMaintain = gainLoseMaintain
    }
    
    static func getGainLoseMaintain() -> String {
        return  self.gainLoseMaintain
    }
    
    static func setDaysToComplete(daysToComplete: Int) {
        self.daysToComplete = daysToComplete
    }
    
    static func getDaystoComplete() -> Int {
        return self.daysToComplete
    }
    
    static func setWeightChangeGoal(weightChangeGoal: String) {
        self.weightChangeGoal = weightChangeGoal
    }
    
    static func getWeightChangeGoal() -> String {
        return self.weightChangeGoal
    }
    
    static func setWeeksToComplete(weeksToComplete: Int) {
        self.weeksToComplete = weeksToComplete
    }
    
    static func getWeeksToComplete() -> Int {
        return self.weeksToComplete
    }
    
    static func setTodaysCaloriesConsumed(todaysCaloriesConsumed: Double) {
        self.todaysCaloriesConsumed = todaysCaloriesConsumed
    }
    
    static func getTodaysCaloriesConsumed() -> Double {
        return self.todaysCaloriesConsumed
    }
    
    static func calculateDesiredWeight() -> Double {
        if self.gainLoseMaintain == "maintain" {
            return self.weight
        } else if self.gainLoseMaintain == "lose" {
            return self.weight - Double(self.weightChangeGoal)!
        } else {
            return self.weight + Double(self.weightChangeGoal)!
        }
    }
    
    static func calculateBMR() -> Double {
        var BMR = 4.536 * Double(self.weight)
        BMR += 15.88 * Double(self.height)!
        BMR -= 5.0 * Double(self.age)!
        
        let isMan: Bool = self.sex == 1
        
        if isMan {
            BMR += 5.0
        } else {
            BMR -= 161
        }
        return BMR
    }
    
    static func getMaintenence() -> Double {
        var maintenence = 0.0
        var BMR = self.calculateBMR()
        if self.sex == 1 {
            maintenence = BMR + 700
        } else {
            maintenence = BMR + 450
        }
        return maintenence
    }
    
    static func getCaloriesToBurnFromExerciseToday() -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var day = getDayOfWeek(formatter.string(from: Date()))
        if day == 1 || day == 7 {
            self.caloriesToBurnFromExerciseToday = 100
        } else {
            self.caloriesToBurnFromExerciseToday = 500
        }
        return self.caloriesToBurnFromExerciseToday
    }
    
    
    static func getTotalCaloriesToBurnToday() -> Double {
        var totalCaloriesToBurnToday :Double = 0.0
        if self.gainLoseMaintain == "maintain" {
            totalCaloriesToBurnToday = Double(self.weightChangeGoal)! + self.getCaloriesToBurnFromExerciseToday()
        }
        if gainLoseMaintain == "gain" {
            totalCaloriesToBurnToday = self.getMaintenence() + self.getCaloriesToBurnFromExerciseToday()
        }
        if gainLoseMaintain == "lose" {
            totalCaloriesToBurnToday = self.getMaintenence() + self.getCaloriesToBurnFromExerciseToday()
        }
        return totalCaloriesToBurnToday
    }
    
    
    static func getTodaysCalorieIntake() -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var day = self.getDayOfWeek(formatter.string(from: Date()))
        
        var intake: Double = 0.0
        if self.gainLoseMaintain == "maintain" {
            intake = self.getMaintenence() + self.getCaloriesToBurnFromExerciseToday()
        }
        if self.gainLoseMaintain == "gain" {
            intake = self.getMaintenence() + self.getCaloriesToBurnFromExerciseToday() + Double(self.calculateCalorieDeltaPerDay())
        }
        var calorieDeltaPerDay = 0
        if self.gainLoseMaintain == "lose" {
            if day == 1 || day == 7 {
                calorieDeltaPerDay += 400
            } else {
                calorieDeltaPerDay -= 175
            }
            intake = self.getMaintenence() + self.getCaloriesToBurnFromExerciseToday() - Double(self.calculateCalorieDeltaPerDay())
            
        }
        return intake
    }
    
    static func calculateCalorieDeltaPerDay() -> Int {
        var calorieDelta = 0
        var calorieDeltaPerDay = 0
        
        if self.getGainLoseMaintain() == "gain" {
            calorieDelta = Int(abs(3555 * (PersonInfo.calculateDesiredWeight() - PersonInfo.getWeight())))
        }
        if PersonInfo.getGainLoseMaintain() == "lose" {
            calorieDelta = Int(abs(3555 * (PersonInfo.getWeight()-PersonInfo.calculateDesiredWeight())))
        }
        calorieDeltaPerDay = Int(Double(calorieDelta)/Double(self.daysToComplete))
        return calorieDeltaPerDay
        
        
    }
    
    static func getDayOfWeek(_ today:String) -> Int? {
        let formatter = DateFormatter()
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    static func calculateMonthsSinceAppDownload(logDateObjectList: [LogDate]) -> Int {
        let monthsSinceAppDownload = 2 + Int(logDateObjectList.count/30)
        return monthsSinceAppDownload
    }
    
}

