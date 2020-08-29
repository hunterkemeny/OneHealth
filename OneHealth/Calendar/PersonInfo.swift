//
//  PersonInfo.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/28/20.
//

import Foundation

class PersonInfo
{
    static var weight: Int = 0
    static var desiredWeight: Int = 0
    static var height: Int = 0
    static var sex: Int = 0//Men will be number 1 :)
    static var age: Int = 0
    static var weightStatus: Int = 0 //-1 for lose, 0 for maintain, 1 for gain
    static var timeToCompleteGoal: Int = 0 //IN DAYS
    static var maintenence: Double = 0.0
    static var dailyCalorieDelta:Double = 0.0
    static var email: String?
    static var averageCaloriesBurnedLastWeek: Double = 0.0
    static var yesterdaysCalories: String?
    static var caloriesBurnedYesterday: Double = 0.0
    //static var caloriesInAllTime:
    
    
    static func makePerson(w: Int, h: Int, s:Int, a:Int, dw: Int, t:Int) {
        weight = w
        desiredWeight = dw
        height = h
        sex = s
        age = a
        timeToCompleteGoal = t
    }
    
    static func setWeight(w: Int){
        weight = w
    }
    
    static func getWeight() -> Int
    {
        return weight
    }
    
    static func setHeight(h:Int){
        height = h
    }
    
    static func getHeight() -> Int {
        return height
    }
    
    static func setSex(s:Int){
        sex = s
    }
    
    static func getSex() -> Int
    {
        return sex
    }
    
    static func setAge(a:Int){
        age = a
    }
    
    static func getAge() -> Int{
        
        return age
    }
    
    static func setWeightStatus(sw:Int){
        weightStatus = sw
    }
    
    static func getWeightStatus() -> Int{
        return  weightStatus
    }
    
    static func setTimetoCompleteGoal(t:Int){
        timeToCompleteGoal = t
    }
    
    static func getTimetoCompleteGoal() -> Int{
        return timeToCompleteGoal
    }
    
    static func setMaintenence(m: Double){
        maintenence = m
    }
    
    static func getMaintenence()->Double{
        return maintenence
    }
    
    static func setDesiredWeight(dw: Int){
        desiredWeight = dw
    }
    
    static func getDesiredWeight() -> Int {
        return desiredWeight
    }
    
    static func setDelta(c:Double){
        dailyCalorieDelta = c
    }
    
    static func getDelta()->Double{
        return dailyCalorieDelta
    }
    
    static func setCaloriesBurnedLastWeek(cb: Double) {
        averageCaloriesBurnedLastWeek = cb
    }
    
    static func getCaloriesBurnedLastWeek() -> Double {
        return averageCaloriesBurnedLastWeek
    }
    
    static func setYesterdaysCalories(yc: String) {
        yesterdaysCalories = yc
    }
    
    static func getYesterdaysCalories() -> String {
        return yesterdaysCalories ?? ""
    }
    
    static func setCaloriesBurnedYesterday(yb: Double) {
        caloriesBurnedYesterday = yb
    }
    
    static func getCaloriesBurnedYesterday() -> Double {
        return caloriesBurnedYesterday
    }
}

