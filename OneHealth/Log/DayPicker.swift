//
//  DayPicker.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import Foundation

class DayPicker {
    static var date: Date?
    static var stringDate: String? = ""
    static var weight: Double? = 0.0
    static var water: String? = ""
    static var meditation: String? = ""
    static var fast: String? = ""
    
    static func setDate(d: Date) {
        date = d
    }
    
    static func getDate() -> Date {
        return date!
    }
    
    static func setStringDate(sd: String) {
        stringDate = sd
    }
    
    static func getStringDate() -> String {
        return stringDate!
    }
    
    static func setWeight(w: Double) {
        weight = w
    }
    
    static func getWeight() -> Double {
        return weight!
    }
    
    static func setWater(wa: String) {
        water = wa
    }
    
    static func getWater() -> String {
        return water!
    }
    
    static func setMeditation(m: String) {
        meditation = m
    }
    
    static func getMeditation() -> String {
        return meditation!
    }
    
    static func setFast(f: String) {
        fast = f
    }
    
    static func getFast() -> String {
        return fast!
    }
}
