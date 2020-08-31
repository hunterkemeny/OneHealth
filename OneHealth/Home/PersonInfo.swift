//
//  PersonInfo.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import Foundation
// Need to get rid of personinfo? Or add to onboarding process?
class PersonInfo {
    static var weight: Int = 0
    static var desiredWeight: Int = 0
    static var height: Int = 0
    static var sex: Int = 0 //Men are 1, women are 0.
    static var age: Int = 0
    static var gainLoseMaintain: Int = 0 // -1 for lose, 0 for maintain, 1 for gain
    static var daysToCompleteGoal: Int = 0 // in days
    static var maintenence: Double = 0.0
    static var dailyCalorieDelta:Double = 0.0
    static var email: String?
    static var averageCaloriesBurnedLastWeek: Double = 0.0
    static var todaysCaloriesConsumed: String?
    static var caloriesBurnedYesterday: Double = 0.0
    static var BMR: Double = 0.0
    static var monthsSinceAppDownload: Int = 0
    
    static func makePerson(weight: Int, height: Int, sex: Int, age: Int, desiredWeight: Int, daysToCompleteGoal: Int) {
        self.weight = weight
        self.desiredWeight = desiredWeight
        self.height = height
        self.sex = sex
        self.age = age
        self.daysToCompleteGoal = daysToCompleteGoal
    }
    
    static func setWeight(weight: Int) {
        self.weight = weight
    }
    
    static func getWeight() -> Int
    {
        return self.weight
    }
    
    static func setHeight(height: Int) {
        self.height = height
    }
    
    static func getHeight() -> Int {
        return self.height
    }
    
    static func setSex(sex: Int) {
        self.sex = sex
    }
    
    static func getSex() -> Int
    {
        return sex
    }
    
    static func setAge(age: Int) {
        self.age = age
    }
    
    static func getAge() -> Int {
        return age
    }
    
    static func setGainLoseMaintain(gainLoseMaintain: Int) {
        self.gainLoseMaintain = gainLoseMaintain
    }
    
    static func getGainLoseMaintain() -> Int {
        return  self.gainLoseMaintain
    }
    
    static func setDaysToCompleteGoal(daysToCompleteGoal:Int) {
        self.daysToCompleteGoal = daysToCompleteGoal
    }
    
    static func getDaystoCompleteGoal() -> Int {
        return self.daysToCompleteGoal
    }
    
    static func setMaintenence(maintenence: Double) {
        self.maintenence = maintenence
    }
    
    static func getMaintenence()->Double {
        return self.maintenence
    }
    
    static func setDesiredWeight(desiredWeight: Int) {
        self.desiredWeight = desiredWeight
    }
    
    static func getDesiredWeight() -> Int {
        return self.desiredWeight
    }
    
    static func setDailyCalorieDelta(dailyCalorieDelta: Double) {
        self.dailyCalorieDelta = dailyCalorieDelta
    }
    
    static func getDailyCalorieDelta()->Double {
        return self.dailyCalorieDelta
    }
    
    static func setTodaysCaloriesConsumed(todaysCaloriesConsumed: String) {
        self.todaysCaloriesConsumed = todaysCaloriesConsumed
    }
    
    static func getTodaysCaloriesConsumed() -> String {
        return self.todaysCaloriesConsumed ?? ""
    }
    
    static func setCaloriesBurnedYesterday(caloriesBurnedYesterday: Double) {
        self.caloriesBurnedYesterday = caloriesBurnedYesterday
    }
    
    static func getCaloriesBurnedYesterday() -> Double {
        return self.caloriesBurnedYesterday
    }
    
    static func calculateBMR() -> Double {
        self.BMR = 4.536 * Double(PersonInfo.getWeight())
        self.BMR += 15.88 * Double(PersonInfo.getHeight())
        self.BMR -= 5.0 * Double(PersonInfo.getAge())
        
        let isMan: Bool = PersonInfo.getSex() == 1
        
        if isMan {
            self.BMR += 5.0
        } else {
            self.BMR -= 161
        }
        return self.BMR
    }
    
    static func calculateMonthsSinceAppDownload(logDateObjectList: [LogDate]) -> Int {
        monthsSinceAppDownload = 2 + Int(logDateObjectList.count/30)
        return monthsSinceAppDownload
    }
    
}

